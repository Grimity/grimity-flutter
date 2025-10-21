import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';

class GrimityCheckBox extends StatelessWidget {
  const GrimityCheckBox({super.key, required this.value, this.onChanged});

  final bool value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GrimityAnimationButton(
      onTap: () {
        onChanged?.call(!value);
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

  static withLabeled({
    required bool value,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          GrimityCheckBox(value: value),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.gray700,
            ),
          ),
        ],
      ),
    );
  }

  static withFoldable({
    required bool value,
    required bool isVisible,
    required VoidCallback onSelect,
    required Widget child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      child: IgnorePointer(
        ignoring: isVisible,
        child: Row(
          children: [
            AnimatedAlign(
              widthFactor: isVisible ? 1 : 0,
              alignment: Alignment.centerLeft,
              duration: Duration(milliseconds: 250),
              curve: Curves.ease,
              child: AnimatedOpacity(
                opacity: isVisible ? 1 : 0,
                duration: Duration(milliseconds: 250),
                curve: Curves.ease,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: GrimityCheckBox(value: value),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
