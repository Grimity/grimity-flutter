import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:grimity/presentation/sign_in/pages/sign_in_page.dart';

/// 인증 상태에 따라 스플레시 이미지, 로그인 혹은 메인 화면을 표시하는 시작 페이지.
class SplashPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppUser.statusNotifier,
      builder: (context, child) {
        return GdsTransition.crossFade(
          animation: .slow,
          value: AppUser.status,
          child: child!,
        );
      },
      child: Builder(
        builder: (context) {
          if (AppUser.status == .loading) {
            // TODO: 임시 스플레시
            return Center(child: GdsCircularLoading());
          }

          if (AppUser.status == .unauth) {
            return SignInPage();
          }

          return NavigationPage();
        },
      ),
    );
  }
}
