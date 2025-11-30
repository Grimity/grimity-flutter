import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';

class BlockedUsersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BlockedUsersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('차단 목록', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.kToolbarHeight.height);
}
