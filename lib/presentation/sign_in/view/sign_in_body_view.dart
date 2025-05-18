import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/presentation/sign_in/provider/sign_in_provider.dart';
import 'package:grimity/presentation/sign_in/widget/sso_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInBodyView extends ConsumerWidget {
  const SignInBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "그림이\n시작이 되는 커뮤니티",
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: AppColor.gray00),
              ),
              Gap(8),
              Text(
                "그리고, 좋아하고, 연결되는 곳",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: AppColor.gray00),
              ),
              Gap(40),
              KakaoSSOButton(
                onTap: () {
                  ref.read(signInProvider.notifier).login(ref, LoginProvider.kakao);
                },
              ),
              Gap(8),
              GoogleSSOButton(
                onTap: () {
                  ref.read(signInProvider.notifier).login(ref, LoginProvider.google);
                },
              ),
              Gap(8),
              AppleSSOButton(
                onTap: () {
                  ref.read(signInProvider.notifier).login(ref, LoginProvider.apple);
                },
              ),
              Gap(36),
            ],
          ),
        ),
      ),
    );
  }
}
