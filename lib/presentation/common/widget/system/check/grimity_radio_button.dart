import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityRadioButton extends StatelessWidget {
  const GrimityRadioButton({super.key, required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child:
            value
                ? Assets.icons.report.radioOn.svg(width: 24, height: 24)
                : Assets.icons.report.raidoOff.svg(width: 24, height: 24),
      ),
    );
  }
}
