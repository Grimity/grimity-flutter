import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_oauth.dart';
import 'package:grimity/app/app_firebase.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/network/app_network.dart';
import 'package:grimity/presentation/sign_in/pages/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 초기화.
  await Firebase.initializeApp(options: AppFirebase.options);

  // 로그인 관련 플러그인 초기화.
  AppOAuth.setup();

  // API 관련 설정 초기화.
  Api.setup(AppNetwork.dio);

  // 사용자 정보 초기화.
  AppUser.setup();

  runApp(const GrimityApp());
}

/// 그리미티 앱의 최상위 위젯.
class GrimityApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    assert(AppUser.status != .none, '해당 시점에서는 이미 사용자 정보가 초기화되어야 합니다.');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;

        return GdsThemeScope(
          theme: brightness == .dark ? .dark() : .light(),
          child: child!,
        );
      },
      home: SignInPage(),
    );
  }
}
