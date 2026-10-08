import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/sign_in/widgets/sign_in_body_view.dart';
import 'package:grimity/presentation/sign_in/widgets/sign_in_gradient.dart';

/// 콜라주 배경과 함께 소셜 로그인을 안내하는 진입 화면.
class SignInPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> signIn(AuthProvider provider) async {
    final response = await AppUser.signIn(context.device, provider);
    debugPrint('test: $response');
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
          body: SignInBodyView(
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
