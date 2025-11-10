import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';

class GrimityCircularProgressIndicator extends StatelessWidget {
  const GrimityCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: AppColor.main, backgroundColor: AppColor.gray300, strokeWidth: 2),
    );
  }
}
