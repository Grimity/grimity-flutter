import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';

class NewChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("메세지 보내기"),
      titleSpacing: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}