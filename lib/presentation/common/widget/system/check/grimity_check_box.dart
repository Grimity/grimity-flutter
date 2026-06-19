import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class GrimityCheckBox extends StatelessWidget {
  const GrimityCheckBox({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  final bool isChecked;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GdsCheckbox(
      isChecked: isChecked,
      onTap: () => onChanged?.call(!isChecked),
    );
  }

  static GdsGesture withLabeled({
    required bool isChecked,
    required String label,
    required VoidCallback onTap,
  }) {
    return GdsGesture(
      onTap: onTap,
      child: Builder(
        builder: (context) {
          final colors = context.gdsColors;

          return Row(
            mainAxisSize: MainAxisSize.min,
            spacing: GdsSpacing.spacing6,
            children: [
              GrimityCheckBox(isChecked: isChecked, onChanged: (_) => onTap()),
              Text(label, style: GdsTypography.label3.copyWith(color: colors.text.grayNormal)),
            ],
          );
        },
      ),
    );
  }

  static GrimityGesture withFoldable({
    required bool isChecked,
    required bool isVisible,
    required VoidCallback onSelect,
    required Widget child,
  }) {
    return GrimityGesture(
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
                child: Padding(padding: EdgeInsets.only(right: 16), child: GrimityCheckBox(isChecked: isChecked)),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
