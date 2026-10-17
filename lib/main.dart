import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_oauth.dart';
import 'package:grimity/app/app_firebase.dart';
import 'package:grimity/app/app_photo.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/network/app_network.dart';
import 'package:grimity/presentation/splash/splash_page.dart';
import 'package:grimity/util/preload_image.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 첫 화면에 표시할 스플래시 로고 이미지를 미리 불러오기.
  await preloadImage(SplashPage.logoImage);

  // 파이어베이스 초기화.
  await Firebase.initializeApp(options: AppFirebase.options);

  // 사진 접근 권한 상태 초기화.
  await AppPhoto.initialize();

  // 로그인 관련 플러그인 초기화.
  AppOAuth.setup();

  // API 관련 설정 초기화.
  Api.setup(AppNetwork.dio);

  // 사용자 정보 초기화.
  AppUser.initialize();

  // 앱이 다시 활성화되면 사진 접근 권한 상태 갱신.
  AppLifecycleListener(
    onResume: AppPhoto.initialize,
  );

  runApp(const GrimityApp());
}

/// 그리미티 앱의 최상위 위젯.
class GrimityApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const GdsApp(
      themeMode: .system, // TODO
      initialPage: SplashPage(),
    );
  }
}
