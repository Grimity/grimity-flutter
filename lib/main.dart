// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:io';

import 'package:grimity/app/settings/app_settings.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/network/app_network.dart';
import 'package:grimity/presentation/splash/splash_page.dart';
import 'package:grimity/util/preload_image.dart';

/// Flutter 테스트 환경에서 실행 중인지 여부.
final kTestMode = Platform.environment.containsKey('FLUTTER_TEST');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 첫 화면에 표시할 스플래시 로고 이미지를 미리 불러오기.
  await preloadImage(SplashPage.logoImage);

  // 앱 설정 초기화.
  await AppSettings.initialize();

  // API 관련 설정 초기화.
  Api.setup(AppNetwork.dio);

  runApp(const GrimityApp());
}

/// 그리미티 앱의 최상위 위젯.
class GrimityApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 테마 설정 변경에 따라 앱 테마 갱신.
    return ListenableBuilder(
      listenable: AppSettings.theme,
      builder: (context, child) {
        return GdsApp(
          themeMode: AppSettings.theme.value,
          initialPage: child!,
        );
      },
      child: const SplashPage(),
    );
  }
}
