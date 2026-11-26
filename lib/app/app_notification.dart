// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide NotificationResponse;
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_device.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/main.dart';
import 'package:grimity/presentation/chat_list/pages/chat_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// 백그라운드에서 FCM 푸시를 받는 진입점.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 알림 표시는 OS에서 처리.
}

/// Firebase FCM을 통한 푸시 알림 수신과 관련 동작을 처리합니다.
abstract final class AppNotification {
  /// 앱 실행 중 수신한 푸시를 시스템 알림으로 표시하는 플러그인.
  static final localNotificationPlugin = FlutterLocalNotificationsPlugin();

  /// 플랫폼별 로컬 알림 초기화 설정.
  static const localNotificationSettings = InitializationSettings(
    android: .new('ic_notification'),
    iOS: .new(
      requestSoundPermission: false,
      requestAlertPermission: false,
      requestBadgePermission: false,
    ),
  );

  /// 플랫폼별 알림 표시 설정.
  static const details = NotificationDetails(
    android: .new(
      'default_channel',
      'Default',
      channelDescription: 'default channel',
      importance: .max,
      priority: .high,
      number: 0,
    ),
    iOS: .new(
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
    ),
  );

  /// Android에서 푸시 알림을 표시할 때 사용하는 알림 채널.
  static final androidChannel = AndroidNotificationChannel(
    'default_channel',
    'Default',
    description: 'default channel',
    importance: .max,
  );

  /// 앱 실행 중 새 푸시 메시지가 수신되면 변경을 알리는 알림.
  static final notifier = Notifier();

  /// 기존에 등록한 토큰과 다른 경우 기기 식별자와 함께 서버에 등록합니다.
  static Future<void> syncToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenKey = 'fcm_token:${profile.id}';
    final sentToken = prefs.getString(tokenKey);
    if (sentToken == token) return;

    // 멀티 디바이스 지원을 위해 기기 식별자도 함께 전달.
    final device = await AppDevice.info;

    await PutMePushToken(
      request: .new(deviceId: device.id!, token: token),
    ).request();

    // 서버에 등록한 FCM 토큰 기록.
    await prefs.setString(tokenKey, token);
  }

  /// FCM 토큰이 갱신되면 새 토큰을 서버에 등록합니다.
  static void onTokenRefresh(String newToken) {
    syncToken(newToken);
  }

  /// 필요한 알림 권한을 요청합니다.
  static Future<bool> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // 사용자가 알림 권한을 거부한 경우.
    if (settings.authorizationStatus == .denied) {
      return false;
    }

    return true;
  }

  /// FCM 토큰을 등록하고 토큰 갱신과 푸시 수신 이벤트를 구독합니다.
  static Future<void> initializeToken() async {
    // 서버가 FCM 토큰을 받으므로 기존 토큰 API 사용.
    // ignore: deprecated_member_use
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await syncToken(fcmToken);
    }

    // ignore: deprecated_member_use
    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefresh);
    FirebaseMessaging.onMessage.listen(onForegroundMessage);

    // 앱이 완전히 종료된 상태에서 알림을 선택해 실행한 경우.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onBackgroundMessageClicked(initialMessage);
    }

    // 종료 상태에서 선택한 로컬 알림은 초기화 콜백 대신 실행 정보로 전달됨.
    final launchDetails = await localNotificationPlugin.getNotificationAppLaunchDetails();
    final payload = launchDetails?.notificationResponse?.payload;

    // 로컬 알림을 눌러 앱이 실행된 경우 해당 알림 처리.
    if (launchDetails?.didNotificationLaunchApp == true && payload != null) {
      onMessageClicked(RemoteMessage.fromMap(jsonDecode(payload)));
    }

    // 백그라운드에서 알림을 선택해 앱으로 복귀한 경우.
    FirebaseMessaging.onMessageOpenedApp.listen(onBackgroundMessageClicked);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// 알림 권한을 요청하고 푸시 토큰 등록과 메시지 수신을 설정합니다.
  static Future<void> register() async {
    assert(AppUser.status == .loaded);
    if (kTestMode) return;

    final hasPermission = await requestPermission();
    if (hasPermission) {
      await initializeToken();
    }
  }

  /// 앱 실행 중 알림을 표시하기 위한 로컬 알림 플러그인을 초기화합니다.
  static Future<void> initialize() async {
    await localNotificationPlugin.initialize(
      settings: localNotificationSettings,

      // 사용자가 알림을 누르면 포함된 데이터를 읽어 관련 동작 처리.
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) {
          throw StateError('수신된 로컬 알림에 처리할 데이터가 없습니다.');
        }

        onMessageClicked(
          RemoteMessage.fromMap(jsonDecode(response.payload!)),
        );
      },
    );

    // 백그라운드 FCM 알림도 동일한 채널 사용.
    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 푸시 알림 수신 시 사용자 정보와 채팅 목록 갱신.
    notifier.addListener(AppUser.refresh);
    notifier.addListener(ChatListPage.refreshNotifier.notify);
  }

  /// 앱 실행 중 수신한 메시지를 전달하고 이를 소비하는 화면이 없으면 알림을 표시합니다.
  static void onForegroundMessage(RemoteMessage message) async {
    notifier.notify();

    final notification = message.notification;
    if (notification != null) {
      localNotificationPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: details,
        payload: jsonEncode(message.toMap()),
      );
    }
  }

  /// 백그라운드 또는 종료된 상태에서 선택한 알림을 처리합니다.
  static void onBackgroundMessageClicked(RemoteMessage message) {
    onMessageClicked(message);
  }

  /// 선택한 알림을 읽음 처리하고 포함된 딥링크를 처리합니다.
  static Future<void> onMessageClicked(RemoteMessage message) async {
    debugPrint('[푸시 알림 클릭] ${message.data}');
    if (message.data.isNotEmpty) {
      final data = message.data['data'] as String?;
      final event = message.data['event'];
      final deepLink = message.data['deepLink'] as String?;

      // 사용자가 선택한 알림 읽음 처리.
      if (event == 'newNotification') {
        if (data == null) {
          throw StateError('새 알림의 푸시 메시지에는 알림 데이터가 필요합니다.');
        }

        final notification = NotificationResponse.codec.decode(
          jsonDecode(data),
        );

        PutNotificationsById(id: notification.id).request();
      }

      // 알림에 포함된 링크를 외부 앱으로 열기.
      if (deepLink != null) {
        await launchUrl(
          Uri.parse('https://www.grimity.com').resolve(deepLink),
          mode: .externalApplication,
        );
      }
    }
  }
}
