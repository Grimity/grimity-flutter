import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';

class GrimitySwitch extends StatelessWidget {
  const GrimitySwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.gray00,
      activeTrackColor: AppColor.main,
      inactiveThumbColor: AppColor.gray00,
      inactiveTrackColor: AppColor.gray400,
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return null;
        }
        return AppColor.gray400;
      }),
    );
  }
}
