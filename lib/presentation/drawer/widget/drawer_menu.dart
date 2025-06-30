import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/drawer/enum/drawer_menu_item.dart';

class DrawerMenuListView extends StatelessWidget {
  const DrawerMenuListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [...DrawerMenuItem.values.map((e) => _DrawerMenuListTile(drawerMenuItem: e))]);
  }
}

class _DrawerMenuListTile extends StatelessWidget {
  const _DrawerMenuListTile({required this.drawerMenuItem});

  final DrawerMenuItem drawerMenuItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {
        Scaffold.of(context).closeEndDrawer();
        if (drawerMenuItem.isGo) {
          context.go(drawerMenuItem.path);
        } else {
          context.push(drawerMenuItem.path);
        }
      },
      minLeadingWidth: 10.w,
      leading: SvgPicture.asset(drawerMenuItem.icon.path, width: 16),
      title: Text(drawerMenuItem.title, style: AppTypeface.label1.copyWith(color: AppColor.gray600)),
    );
  }
}
