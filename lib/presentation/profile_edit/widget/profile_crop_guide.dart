import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class ProfileGuide extends StatelessWidget {
  const ProfileGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.icons.profileEdit.move.svg(width: 32, height: 32),
        Gap(18),
        Text('사진을 끌어서 위치를 조정해보세요', style: AppTypeface.label2.copyWith(color: AppColor.gray00)),
      ],
    );
  }
}
