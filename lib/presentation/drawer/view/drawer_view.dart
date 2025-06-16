import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({
    super.key,
    required this.closeButton,
    required this.profileWidget,
    required this.uploadButton,
    required this.menuListView,
  });

  final Widget closeButton;
  final Widget profileWidget;
  final Widget uploadButton;
  final Widget menuListView;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.gray00,
      width: 260.w,
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(children: [closeButton, profileWidget, Gap(24), uploadButton, Gap(24)]),
            ),
            Divider(height: 1, color: AppColor.gray300),
            Gap(24),
            menuListView,
          ],
        ),
      ),
    );
  }
}
