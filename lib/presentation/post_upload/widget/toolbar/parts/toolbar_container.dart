import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';

class ToolbarContainer extends StatelessWidget {
  const ToolbarContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.gray00,
        border: Border(top: BorderSide(color: AppColor.gray300, width: 1)),
      ),
      height: 42,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: child),
    );
  }
}
