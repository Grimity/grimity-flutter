import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingProfileUrlView extends HookConsumerWidget {
  const SettingProfileUrlView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final state = ref.watch(profileEditProvider);
    final controller = useTextEditingController();
    final errorText = ref.read(profileEditProvider).urlCheckMessage;
    final isError = errorText?.isNotEmpty ?? false;

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
                '프로필 URL를 정해주세요',
                style:
                    context.isMobile
                        ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                        : GdsTypography.title1.copyWith(color: colors.text.grayBold),
              ),
              Gap(GdsSpacing.spacing40),
              Text(
                'www.grimity.com/',
                style: GdsTypography.title2.copyWith(color: colors.text.grayBold),
              ),
              Gap(GdsSpacing.spacing12),
              GdsInput.custom(
                helperText: errorText,
                error: isError,
                child: GdsTextField(
                  placeholder: '숫자, 영문(소문자), 언더바(_)',
                  controller: controller,
                  onChanged: ref.read(profileEditProvider.notifier).updateUrl,
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
