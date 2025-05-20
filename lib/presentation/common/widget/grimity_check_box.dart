import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';

class GrimityCheckBox extends StatelessWidget {
  const GrimityCheckBox({super.key, required this.value, required this.onChanged});

  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? AppColor.main : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: value ? Colors.transparent : Colors.grey.shade300, width: 1.5),
        ),
        child: Icon(Icons.check, size: 12, color: value ? Colors.white : Colors.grey.shade300),
      ),
    );
  }
}
