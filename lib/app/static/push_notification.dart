import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide NotificationResponse;
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/network/provider/dio_provider.dart';
import 'package:grimity/app/util/device_info_util.dart';
import 'package:grimity/data/model/notification/notification_response.dart';
import 'package:grimity/data/model/push_notification/push_notification_data_response.dart';
import 'package:grimity/domain/usecase/notifications_usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 백그라운드에서 FCM 푸시를 받는 진입점.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {}
}

/// 앱 내에서 Firebase FCM를 통한 실시간 알림 서비스를 지원하도록 합니다.
class PushNotification {
  static final localNotificationPlugin = FlutterLocalNotificationsPlugin();
  static final localNotificationSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    iOS: DarwinInitializationSettings(
      requestSoundPermission: false,
      requestAlertPermission: false,
      requestBadgePermission: false,
    ),
  );

  // 앱이 포그라운드 상태일 때 Firebase FCM에서 수신한 새 푸시 메시지를 처리하는 스트림입니다.
  static final _streamController = StreamController<RemoteMessage>.broadcast();

  // 외부에서 해당 스트림을 구독하여 실시간으로 푸시 이벤트를 처리할 수 있습니다.
  // 예: 채팅 목록 화면에서 새 메시지 수신 시 UI 갱신
  static Stream<RemoteMessage> get stream => _streamController.stream;

  /// 클라이언트의 현재 FCM 토큰을 서버와 동기화합니다.
  /// 기존에 서버 측에 전송된 토큰과 동일하면 아무 작업도 수행하지 않으며,
  /// 새로운 토큰일 경우 로컬에 이를 저장하고 서버에 업데이트 요청을 합니다.
  static Future<void> syncToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    final String? sentToken = prefs.getString("fcm_token");
    if (sentToken == token) return;

    // 멀티 디바이스 지원을 위해 디바이스 아이디도 포함.
    final request = {"deviceId": await DeviceInfoUtil.getDeviceId(), "token": token};

    await kDio.put("/me/push-token", data: request);

    // 새로운 FCM 토큰 값으로 기록.
    prefs.setString("fcm_token", token);
  }

  /// 기존 FCM 토큰 값이 변경되었을 때 호출됩니다.
  static void onTokenRefresh(String newToken) {
    syncToken(newToken);
  }

  /// 필요한 알림 권한을 요청합니다.
  static Future<bool> initPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false, // 조용한 알림 비활성화
    );

    // 사용자가 알림 권한을 거부한 경우.
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return false;
    }

    return true;
  }

  /// APNs와 FCM 토큰을 초기화하고 갱신을 포함하여 이를 서버와 동기화합니다.
  static Future<void> initializeToken() async {
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await syncToken(fcmToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefresh);
    FirebaseMessaging.onMessage.listen(onForegroundMessage);

    // 백그라운드 조차 아닌 앱이 완전히 꺼진 상태에서의 알림 클릭 후 앱 실행된 경우.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onBackgroundMessageClicked(initialMessage);
    }

    // 앱이 메시지 클릭된 이후 백그라운드에서 포그라운드로 전환된 경우.
    FirebaseMessaging.onMessageOpenedApp.listen(onBackgroundMessageClicked);

    // 앱 실행 여부와 상관 없이 백그라운드나 종료 상태에서 메시지가 도착했을 경우.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// 사용자가 로그인 상태이고 알림 권한을 허용한 경우에만 토큰 초기화를 수행합니다.
  static Future<void> initializeAll() async {
    final hasPermission = await initPermission();
    if (!hasPermission) return;

    await initializeToken();
  }

  // 포그라운드 푸시 알림 구현을 위해 관련 플러그인 초기화를 수행합니다.
  static Future<void> initializePlugin() async {
    await localNotificationPlugin.initialize(
      localNotificationSettings,
      onDidReceiveNotificationResponse: (response) {
        assert(response.payload != null, "FlutterLocalNotificationsPlugin.show 호출 시에 payload를 정의하지 않았을 수 있음.");

        final map = jsonDecode(response.payload!);
        onMessageClicked(RemoteMessage.fromMap(map));
      },
    );
  }

  /// 앱과 관련된 모든 알림 또는 뱃지를 초기화합니다.
  static Future<void> clearAll() async {
    localNotificationPlugin.cancelAll();

    // 알림 배지도 함께 초기화합니다.
    FlutterAppBadge.count(0);
  }

  /// 앱이 포그라운드인 상태에서 푸시 알림 메시지가 전송되었을 때 호출됩니다.
  static void onForegroundMessage(RemoteMessage message) async {
    // 포그라운드 상태에서는 별도의 알림 배지를 표시할 필요가 없음.
    FlutterAppBadge.count(0);

    if (_streamController.hasListener) {
      _streamController.add(message);
      return;
    }

    final notification = message.notification;
    if (notification != null) {
      localNotificationPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          // Android 알림 전송 설정.
          android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            channelDescription: 'default channel',
            importance: Importance.max,
            priority: Priority.high,
            number: 0,
          ),
          // iOS 알림 전송 설정.
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            presentBadge: false,
            badgeNumber: 0,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    }
  }

  /// 앱이 백그라운드 또는 종료된 상태에서 사용자가 푸시 알림을 클릭했을 때 호출됩니다.
  static void onBackgroundMessageClicked(RemoteMessage message) async {
    onMessageClicked(message);
  }

  /// 사용자가 앱의 생명주기와 상관없이 특정 알림을 클릭했을 경우 호출됩니다.
  static void onMessageClicked(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      final response = PushNotificationDataResponse.fromJson(message.data);
      final data = response.data; // 메시지에 포함된 JSON 데이터
      final event = response.event; // 이벤트 종류, 예: 'newNotification'
      final deepLink = response.deepLink; // 딥링크 경로, 예: '/posts/123'

      // 사용자가 클릭한 알림 읽음 처리.
      if (event == "newNotification") {
        assert(data != null, "서버에서는 알림 형태의 푸시 메시지라면 항상 데이터를 같이 전달해야 합니다.");
        final model = NotificationResponse.fromJson(jsonDecode(data!));
        markNotificationAsReadUseCase.execute(model.id);
      }

      // 주어진 딥링크 경로로 페이지 이동.
      if (deepLink != null) {
        handleDeepLink(deepLink);
      }
    }
  }

  /// 위젯 트리가 아직 준비되지 않은 상태에서도 주어진 딥링크를 스케쥴링하여 이를 적절히 처리합니다.
  static void handleDeepLink(String link) {
    final context = rootNavigatorKey.currentContext;

    // 내비게이션 Context가 모두 초기화될 때까지 디링크 처리 보류.
    if (context == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => handleDeepLink(link));
      return;
    }

    context.push(link);
  }
}
