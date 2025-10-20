import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_check_box.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpTermAgreeWidget extends ConsumerWidget {
  const SignUpTermAgreeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        GrimityCheckBox(
          value: ref.watch(signUpProvider).isTermsAgreed,
          onChanged: (value) {
            ref.read(signUpProvider.notifier).updateTermsAgreement(value ?? false);
          },
        ),
        const Gap(8),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(AppConst.serviceTermsUrl));
              },
              child: Text(
                '서비스이용약관',
                style: AppTypeface.caption1.copyWith(color: AppColor.gray700, decoration: TextDecoration.underline),
              ),
            ),
            Text(' 과 ', style: AppTypeface.caption1.copyWith(color: AppColor.gray600)),
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(AppConst.privacyPolicyUrl));
              },
              child: Text(
                '개인정보처리방침',
                style: AppTypeface.caption1.copyWith(color: AppColor.gray700, decoration: TextDecoration.underline),
              ),
            ),
            Text(' 에 동의합니다.', style: AppTypeface.caption1.copyWith(color: AppColor.gray600)),
          ],
        ),
      ],
    );
  }
}
