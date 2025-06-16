import 'package:flutter/material.dart';
import 'package:grimity/presentation/drawer/view/drawer_view.dart';
import 'package:grimity/presentation/drawer/widget/drawer_close_button.dart';
import 'package:grimity/presentation/drawer/widget/drawer_menu.dart';
import 'package:grimity/presentation/drawer/widget/drawer_profile.dart';
import 'package:grimity/presentation/drawer/widget/drawer_upload_button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerView(
      closeButton: DrawerCloseButton(),
      profileWidget: DrawerProfile(),
      uploadButton: DrawerUploadButton(),
      menuListView: DrawerMenuListView(),
    );
  }
}
