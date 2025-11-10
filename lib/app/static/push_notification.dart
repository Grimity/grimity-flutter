import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grimity/app/network/provider/dio_provider.dart';
import 'package:grimity/app/util/device_info_util.dart';
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
    if (Platform.isIOS) {
      final String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) return;
    }

    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await syncToken(fcmToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefresh);
    FirebaseMessaging.onMessage.listen(onForegroundMessage);
  }

  /// 사용자가 로그인 상태이고 알림 권한을 허용한 경우에만 토큰 초기화를 수행합니다.
  static Future<void> initializeAll() async {
    final hasPermission = await initPermission();
    if (!hasPermission) return;

    await initializeToken();
  }

  /// 앱이 포그라운드인 상태에서 푸시 알림 메시지가 전송되었을 때 호출됩니다.
  /// iOS 에서는 이미 설정상으로 포그라운드 상태의 알림을 표시할 수 있도록
  /// 설정했으므로 이를 생략합니다.
  static void onForegroundMessage(RemoteMessage message) async {
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
          ),
          // iOS 알림 전송 설정.
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
      );
    }
  }
}
