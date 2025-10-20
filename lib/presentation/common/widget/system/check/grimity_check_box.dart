import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';

class GrimityCheckBox extends StatelessWidget {
  const GrimityCheckBox({super.key, required this.value, required this.onChanged});

  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return GrimityAnimationButton(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 24,
        height: 24,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? AppColor.main : AppColor.gray00,
          borderRadius: BorderRadius.circular(5),
          border: value ? null : Border.all(color: AppColor.gray400, width: 1),
        ),
        child: Assets.icons.common.check.svg(
          width: 12,
          height: 12,
          colorFilter: ColorFilter.mode(value ? AppColor.gray00 : AppColor.gray300, BlendMode.srcIn),
        ),
      ),
    );
  }
}
