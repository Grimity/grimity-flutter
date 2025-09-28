import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingFooter extends StatelessWidget {
  const SettingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 30), child: _LogoutTextButton()),
        Divider(height: 1, color: AppColor.gray300),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(AppConst.privacyPolicyUrl));
                    },
                    child: Text('개인정보취급방침', style: AppTypeface.caption2.copyWith(color: AppColor.gray500)),
                  ),
                  GrimityGrayCircle(),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(AppConst.serviceTermsUrl));
                    },
                    child: Text('이용약관', style: AppTypeface.caption2.copyWith(color: AppColor.gray500)),
                  ),
                ],
              ),
              Gap(4),
              Text('© Grimity. All rights reserved.', style: AppTypeface.caption2.copyWith(color: AppColor.gray500)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoutTextButton extends ConsumerWidget {
  const _LogoutTextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final user = ref.read(userAuthProvider);
        if (user == null) return;
        final provider = LoginProviderX.fromString(user.provider ?? '');
        await completeLogoutProcessUseCase.execute(provider);
        if (context.mounted) {
          SignInRoute().go(context);
        }
      },
      child: Text(
        '로그아웃',
        style: AppTypeface.label2.copyWith(
          color: AppColor.gray600,
          decoration: TextDecoration.underline,
          decorationColor: AppColor.gray500,
          decorationThickness: 1,
        ),
      ),
    );
  }
}
