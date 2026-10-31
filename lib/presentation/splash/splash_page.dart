// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

// ignore_for_file: gds_lints/prefer_gds_image

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_firebase.dart';
import 'package:grimity/app/app_oauth.dart';
import 'package:grimity/app/app_photo.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:grimity/presentation/sign_in/pages/sign_in_page.dart';
import 'package:pervice/pervice.dart';

/// 인증 상태에 따라 스플레시 이미지, 로그인 혹은 메인 화면을 표시하는 시작 페이지.
class SplashPage extends StatelessWidget {
  const new({super.key});

  /// 네이티브와 Flutter 스플래시에서 공통으로 사용하는 로고 이미지.
  static const logoImage = AssetImage('assets/images/splash_logo.png');

  /// 앱 초기화 작업의 중복 실행을 방지하기 위한 Future.
  static Future<void>? loadFuture;

  /// 앱 시작에 필요한 초기화 작업을 수행합니다.
  Future<void> load() async {
    // 파이어베이스 및 SDK 플러그인 초기화.
    await Firebase.initializeApp(options: AppFirebase.options);
    await AppOAuth.setup();
    await AppPhoto.initialize();

    // 사용자 정보 초기화.
    await AppUser.initialize();

    // 앱이 다시 활성화되면 사진 접근 권한 상태 갱신.
    AppLifecycleListener(
      onResume: AppPhoto.initialize,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch(AppUser.statusNotifier);

    // 스플래시 로고 애니메이션 완료 여부.
    final splashCompleted = context.stateOf(() => false);

    return GdsSplash(
      builder: (context) {
        // 초기화 전이거나 로딩 중인 경우 스플래시 화면 표시.
        if (splashCompleted.value == false) {
          return buildSplash(
            context,
            onDone: () => splashCompleted.value = true,
          );
        }

        // 로그아웃 상태인 경우 로그인 화면 표시.
        if (AppUser.status == .unauth) {
          return SignInPage();
        }

        // 로그인 상태인 경우 홈 화면 표시.
        return NavigationPage();
      },
    );
  }

  /// 네이티브 스플래시와 배경색 및 로고 크기를 그대로 맞춘 로딩 화면.
  Widget buildSplash(
    BuildContext context, {
    required VoidCallback onDone,
  }) {
    final parent = context.useAnimationController(
      duration: .new(milliseconds: 300),
    );

    final curved = context.useCurvedAnimation(
      parent: parent,
      curve: const Cubic(0.8, -1, 0.5, 1),
    );

    if (loadFuture == null) {
      // 로고 애니메이션이 완료되면 다음 화면 표시.
      parent.addStatusListener((status) {
        if (status == .completed) {
          onDone();
        }
      });

      // 초기화가 끝나면 로고 애니메이션 실행.
      loadFuture = load()..whenComplete(parent.forward);

      // 초기화가 끝나면 저장된 Future 해제.
      loadFuture?.whenComplete(() => loadFuture = null);
    }

    return ColoredBox(
      color: const Color(0xFF232332),
      child: Center(
        child: AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 - curved.value,
              child: child,
            );
          },
          child: const Image(
            image: logoImage,
            width: 288,
            height: 288,
          ),
        ),
      ),
    );
  }
}
