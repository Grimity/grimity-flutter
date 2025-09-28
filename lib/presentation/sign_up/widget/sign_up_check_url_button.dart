import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_button.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';

class SignUpCheckUrlButton extends ConsumerWidget {
  const SignUpCheckUrlButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled =
        ValidatorUtil.isValidUrl(ref.watch(signUpProvider).url) &&
        ref.watch(signUpProvider).urlState != GrimityTextFieldState.error;

    return GrimityButton(
      isEnabled: isEnabled,
      '시작하기',
      onTap: () async {
        // URL 유효성 검증
        await ref.read(signUpProvider.notifier).checkUrlValidity();

        // 회원가입 진행
        final result = await ref.read(signUpProvider.notifier).signUp(ref);
        result.fold(
          onSuccess: (user) {
            // 회원 가입 이후 UserAuthProvider User 갱신
            ref.read(userAuthProvider.notifier).setUser(user);

            if (!context.mounted) return;
            HomeRoute().go(context);
          },
          onFailure: (error) {
            ToastService.showError('회원가입에 실패했어요.', showImmediately: true);
          },
        );
      },
    );
  }
}
