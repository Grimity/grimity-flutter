import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({
    super.key,
    required this.closeButton,
    required this.profileWidget,
    required this.uploadButton,
    required this.menuListView,
    required this.drawerFooter,
  });

  final Widget closeButton;
  final Widget profileWidget;
  final Widget uploadButton;
  final Widget menuListView;
  final Widget drawerFooter;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.gray00,
      width: 260,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: [closeButton, profileWidget, Gap(24), uploadButton, Gap(24)]),
                  ),
                  Divider(height: 1, color: AppColor.gray300),
                  Gap(24),
                  menuListView,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: drawerFooter,
            ),
          ],
        ),
      ),
    );
  }
}
