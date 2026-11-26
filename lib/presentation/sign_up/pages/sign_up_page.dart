// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:material_ui/material_ui.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_view.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_nickname_view.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

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
                  mobile: 40.vertical + 16.horizontal,
                  tablet: 48.vertical + 20.horizontal,
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
                  mobile: 24.bottom + 16.horizontal,
                  tablet: 40.bottom + 40.horizontal,
                ),
                child: GdsButton.text(
                  size: .lg,
                  type: .solid,
                  label: view.label,
                  enabled: canSubmit,
                  mainAxisSize: .max,
                  onTap: () async {
                    final nextView = await view.onSubmit(context);

                    // 제출 결과를 반영하고 필요한 경우 다음 단계로 이동.
                    if (context.mounted) {
                      context.setState();

                      if (nextView != null) {
                        controller.push(nextView);
                      }
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
