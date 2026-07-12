import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';

class SignUpButton extends ConsumerWidget {
  const SignUpButton({super.key});

  static const mobilePadding = EdgeInsets.only(
    left: GdsSpacing.spacing16,
    right: GdsSpacing.spacing16,
    bottom: GdsSpacing.spacing24,
  );

  static const tabletPadding = EdgeInsets.only(
    left: GdsSpacing.spacing40,
    right: GdsSpacing.spacing40,
    bottom: GdsSpacing.spacing40,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SignUpState state = ref.watch(signUpProvider);
    final bool enabled = getEnabled(ref, state.signUpViewState);
    final bool loading = getLoading(ref, state.signUpViewState);

    return Padding(
      padding: context.isMobile ? mobilePadding : tabletPadding,
      child: GdsGesture(
        onTap:
            enabled
                ? () async {
                  if (state.signUpViewState == SignUpViewState.nickname) {
                    await ref.read(signUpProvider.notifier).checkNicknameDuplicate();
                  }

                  if (state.signUpViewState == SignUpViewState.url) {
                    // URL 유효성 검증
                    await ref.read(signUpProvider.notifier).checkUrlValidity();

                    // 회원가입 진행
                    if (context.mounted) {
                      await ref.read(signUpProvider.notifier).signUp(ref);
                    }
                  }

                  if (state.signUpViewState == SignUpViewState.welcome) {
                    if (context.mounted) HomeRoute().go(context);
                  }
                }
                : null,
        child: IgnorePointer(
          child: buildRawButton(context, state.signUpViewState, enabled, loading),
        ),
      ),
    );
  }

  bool getEnabled(WidgetRef ref, SignUpViewState viewState) {
    if (viewState == SignUpViewState.nickname) {
      return ref.watch(signUpProvider).nickname.length >= 2 &&
          ref.watch(signUpProvider).isTermsAgreed &&
          ref.watch(signUpProvider).nicknameState != GrimityTextFieldState.error;
    } else if (viewState == SignUpViewState.url) {
      return ValidatorUtil.isAvailableUrl(ref.watch(signUpProvider).url) &&
          ref.watch(signUpProvider).urlState != GrimityTextFieldState.error;
    }

    return true;
  }

  bool getLoading(WidgetRef ref, SignUpViewState viewState) {
    if (viewState == SignUpViewState.nickname) {
      return ref.watch(signUpProvider).isNicknameChecking;
    } else if (viewState == SignUpViewState.url) {
      return ref.watch(signUpProvider).isUrlChecking;
    }

    return false;
  }

  Widget buildRawButton(
    BuildContext context,
    SignUpViewState viewState,
    bool enabled,
    bool loading,
  ) {
    if (viewState == SignUpViewState.nickname) {
      return GdsSolidButton(
        size: GdsSolidButtonSize.large,
        text: '다음',
        enabled: enabled,
        loading: loading,
        expanded: true,
        onPressed: () {},
      );
    } else if (viewState == SignUpViewState.url) {
      return GdsSolidButton(
        size: GdsSolidButtonSize.large,
        text: '완료',
        enabled: enabled,
        loading: loading,
        expanded: true,
        onPressed: () {},
      );
    }

    return GdsSolidButton(
      size: GdsSolidButtonSize.large,
      text: '그리미티 시작하기',
      expanded: true,
      onPressed: () {},
    );
  }
}
