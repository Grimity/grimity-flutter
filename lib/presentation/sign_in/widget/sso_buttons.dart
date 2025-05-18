import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class AppleSSOButton extends StatelessWidget {
  const AppleSSOButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SSOButton(onTap: onTap, name: '애플', icon: Assets.icons.common.apple.svg());
  }
}

class GoogleSSOButton extends StatelessWidget {
  const GoogleSSOButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SSOButton(onTap: onTap, name: '구글', icon: Assets.icons.common.google.svg());
  }
}

class KakaoSSOButton extends StatelessWidget {
  const KakaoSSOButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SSOButton(onTap: onTap, name: '카카오', icon: Assets.icons.common.kakaotalk.svg());
  }
}

class _SSOButton extends StatelessWidget {
  const _SSOButton({required this.onTap, required this.name, required this.icon});

  final VoidCallback onTap;

  final String name;
  final SvgPicture icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: 283,
        height: 52,
        decoration: BoxDecoration(color: AppColor.gray00, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon, Gap(6), Text('$name로 계속하기', style: AppTypeface.subTitle4.copyWith(color: AppColor.gray800))],
        ),
      ),
    );
  }
}
