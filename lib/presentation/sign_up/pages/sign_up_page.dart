import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_view.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_nickname_view.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';

/// 닉네임과 프로필 URL 입력부터 가입 완료까지 단계별 화면을 표시하는 페이지.
class SignUpPage extends StatelessWidget {
  const new({
    super.key,
    required this.provider,
    required this.accessToken,
  });

  /// 회원가입에 사용할 소셜 로그인 유형.
  final AuthProvider provider;

  /// 소셜 로그인으로 발급받은 인증 토큰.
  final String accessToken;

  @override
  Widget build(BuildContext context) {
    final controller = context.useGdsViewStackController<SignUpView>(
      SignUpNicknameView.new,
    );

    return GdsScaffold(
      appBar: GdsTopNavigation.iconButton(
        onBack: () {
          if (!controller.pop()) {
            context.pop();
          }
        },
        actions: [],
      ),
      body: Column(
        children: [
          // 단계별 화면 표시
          Expanded(
            child: GdsViewStack(
              controller: controller,
              builder: (_, view) {
                final EdgeInsets padding = context.whenDevice(
                  mobile: .only(top: 40, bottom: 40, left: 16, right: 16),
                  tablet: .only(top: 48, bottom: 48, left: 20, right: 20),
                );

                return SliverScrollView(
                  padding: view.scrollPadding ?? padding,
                  slivers: [
                    view.build(context),
                  ],
                );
              },
            ),
          ),

          // 현재 화면에 맞춰 하단 액션 바 표시
          ListenableBuilder(
            listenable: controller,
            builder: (_, _) {
              final view = controller.current;
              final canSubmit = view.canSubmit;

              return Padding(
                padding: context.whenDevice(
                  mobile: .only(bottom: 24, left: 16, right: 16),
                  tablet: .only(bottom: 40, left: 40, right: 40),
                ),
                child: GdsButton.text(
                  size: .lg,
                  type: .solid,
                  label: view.label,
                  enabled: canSubmit,
                  mainAxisSize: .max,
                  onTap: () async {
                    final nextView = await view.onSubmit(context);

                    // 다음 단계가 있으면 화면 전환.
                    if (context.mounted && nextView != null) {
                      controller.push(nextView);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
