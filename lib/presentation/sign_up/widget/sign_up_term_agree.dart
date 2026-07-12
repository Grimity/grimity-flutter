import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpTermAgree extends ConsumerWidget {
  const SignUpTermAgree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTermsAgreed = ref.watch(signUpProvider).isTermsAgreed;
    final colors = context.gdsColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GdsSpacing.spacing6,
      children: [
        GdsCheckbox(
          isChecked: isTermsAgreed,
          onTap: () {
            ref.read(signUpProvider.notifier).updateTermsAgreement(!isTermsAgreed);
          },
        ),
        Expanded(
          child: Wrap(
            children: [
              GdsGesture(
                onTap: () async {
                  await launchUrl(Uri.parse(AppConst.serviceTermsUrl));
                },
                child: Text(
                  '서비스이용약관',
                  style: GdsTypography.body1SB.copyWith(
                    color: colors.text.grayBold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                '과 ',
                style: GdsTypography.body1R.copyWith(color: colors.text.grayBold),
              ),
              GdsGesture(
                onTap: () async {
                  await launchUrl(Uri.parse(AppConst.privacyPolicyUrl));
                },
                child: Text(
                  '개인정보처리방침',
                  style: GdsTypography.body1SB.copyWith(
                    color: colors.text.grayBold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                '에 동의합니다.',
                style: GdsTypography.body1R.copyWith(color: colors.text.grayBold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
