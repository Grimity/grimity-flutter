import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_oauth.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/sign_in/widgets/sign_in_body.dart';
import 'package:grimity/presentation/sign_in/widgets/sign_in_gradient.dart';
import 'package:grimity/presentation/sign_up/pages/sign_up_page.dart';

/// 콜라주 배경과 함께 소셜 로그인을 안내하는 진입 화면.
class SignInPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// 소셜 로그인을 진행하고 미가입 사용자는 회원가입 화면으로 이동합니다.
  Future<void> signIn(AuthProvider provider) async {
    final accesssToken = await AppOAuth.signIn(provider);

    // 사용자가 로그인을 취소한 경우.
    if (accesssToken == null) return;

    try {
      await AppUser.signIn(provider, accesssToken);
    } on DioException catch (error) {
      if (!mounted) return;

      // 미가입의 경우 회원가입 페이지로 이동.
      if (error.response?.statusCode == 404) {
        return context.push(SignUpPage(provider: provider, accessToken: accesssToken));
      }

      final errorMessage = switch (error.response?.statusCode) {
        // 유효성 검사에 실패했을 경우.
        400 => '유효성 검사에 실패했어요',

        // 알 수 없는 오류인 경우.
        _ => '알 수 없는 오류가 발생했어요',
      };

      GdsToast.show(context, errorMessage, status: .negative);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GdsArtworkCollage(),

        // 그라디언트 오버레이 표시
        Align(
          alignment: .bottomCenter,
          child: SignInGradient(),
        ),

        GdsScaffold(
          backgroundColor: .transparent,
          body: SignInBody(
            title: '그림이\n시작이 되는 커뮤니티',
            subTitle: '좋아하고 연결되는 곳',
            onKaKao: () => signIn(.kakao),
            onApple: () => signIn(.apple),
            onGoogle: () => signIn(.google),
          ),
        ),
      ],
    );
  }
}
