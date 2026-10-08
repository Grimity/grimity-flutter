import 'dart:io';

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// 앱의 플랫폼별 Firebase 초기화 설정을 제공합니다.
class AppFirebase {
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
