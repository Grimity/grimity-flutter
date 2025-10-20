import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';

class GrimityRadioButton extends StatelessWidget {
  const GrimityRadioButton({super.key, required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GrimityAnimationButton(
      onTap: onTap,
      child:
          value
              ? Assets.icons.report.radioOn.svg(width: 24, height: 24)
              : Assets.icons.report.raidoOff.svg(width: 24, height: 24),
    );
  }
}
