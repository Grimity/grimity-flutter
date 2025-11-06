import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class DrawerCloseButton extends StatelessWidget {
  const DrawerCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GrimityGesture(
        onTap: () => Scaffold.of(context).closeEndDrawer(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
        ),
      ),
    );
  }
}
