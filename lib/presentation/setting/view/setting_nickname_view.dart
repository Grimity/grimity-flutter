import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingNicknameView extends HookConsumerWidget {
  const SettingNicknameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final controller = useTextEditingController();
    final state = ref.watch(profileEditProvider);
    final user = ref.watch(userAuthProvider);
    final errorText = state.nicknameCheckMessage;
    final isError = state.nicknameCheckMessage?.isNotEmpty ?? false;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              top: context.isMobile ? GdsSpacing.spacing40 : GdsSpacing.spacing48,
              left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
              right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
            ),
            children: [
              Text(
                '새로운 닉네임을 입력해주세요',
                style:
                    context.isMobile
                        ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                        : GdsTypography.title1.copyWith(color: colors.text.grayBold),
              ),
              Gap(GdsSpacing.spacing24),
              GdsInput.custom(
                helperText: errorText,
                error: isError,
                child: GdsTextField.count(
                  placeholder: user?.name,
                  controller: controller,
                  maxLength: 12,
                  onChanged: ref.read(profileEditProvider.notifier).updateNickname,
                  onEditingComplete: () => onComplete(context, ref),
                  error: isError,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
            right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
            bottom: context.isMobile ? GdsSpacing.spacing24 : GdsSpacing.spacing40,
          ),
          child: GdsSolidButton(
            size: GdsSolidButtonSize.large,
            text: '저장하기',
            enabled: state.isSaveable,
            loading: state.isLoading,
            expanded: true,
            onPressed: () => onComplete(context, ref),
          ),
        ),
      ],
    );
  }

  void onComplete(BuildContext context, WidgetRef ref) async {
    final isSuccess = await ref.read(profileEditProvider.notifier).updateUser();

    if (context.mounted && isSuccess) {
      context.pop();
    }
  }
}
