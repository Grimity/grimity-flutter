// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// 플랫폼별 Firebase 설정과 오류, 분석 수집 초기화를 관리합니다.
class AppFirebase {
  /// 라우트의 화면 전환을 Analytics에 기록하는 옵저버.
  static final observer = FirebaseAnalyticsObserver(analytics: .instance);

  /// Firebase를 초기화하고 릴리스 빌드의 오류와 앱 실행 정보를 수집합니다.
  static Future<void> initialize() async {
    await Firebase.initializeApp(options: options);

    final crashlytics = FirebaseCrashlytics.instance;
    final analytics = FirebaseAnalytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    await analytics.setAnalyticsCollectionEnabled(kReleaseMode);

    // 디버그 모드인 경우 에러 수집에서 제외.
    if (!kReleaseMode) {
      return;
    }

    // Flutter에서 발생한 오류 기록.
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      crashlytics.recordFlutterFatalError(details);
    };

    // Flutter 밖에서 처리되지 않은 비동기 오류 기록.
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    await analytics.logAppOpen();
  }

  /// 현재 플랫폼에 해당하는 Firebase 설정을 반환합니다.
  static FirebaseOptions get options {
    if (Platform.isAndroid) return _android;
    if (Platform.isIOS) return _ios;

    throw UnsupportedError('현재 플랫폼에서는 Firebase를 지원하지 않습니다.');
  }

  static const FirebaseOptions _android = FirebaseOptions(
    apiKey: 'AIzaSyBpLILsu-W9w-2HUd_0uEu01eWqUjGhKeU',
    appId: '1:50047733044:android:dbd004a2a6896c8d46e961',
    messagingSenderId: '50047733044',
    projectId: 'grimity',
    storageBucket: 'grimity.firebasestorage.app',
  );

  static const FirebaseOptions _ios = FirebaseOptions(
    apiKey: 'AIzaSyBmcElbeX6nrwI-Sz4IZDKUBX7ZxW8WNew',
    appId: '1:50047733044:ios:507d2f5f852047bf46e961',
    messagingSenderId: '50047733044',
    projectId: 'grimity',
    storageBucket: 'grimity.firebasestorage.app',
    androidClientId: '50047733044-llh5i3cbaslfiuf9p2k7u9m1oes29kkh.apps.googleusercontent.com',
    iosClientId: '50047733044-l3hdgkhpmg603v03b7fa7gni87kvpb6u.apps.googleusercontent.com',
    iosBundleId: 'com.grimity.flutter',
  );
}
