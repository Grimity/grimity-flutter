import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/page/setting_entry_page.dart';
import 'package:grimity/presentation/setting/setting_view.dart';
import 'package:grimity/presentation/setting/view/setting_account_view.dart';
import 'package:grimity/presentation/setting/view/setting_entry_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return SettingEntryPage();
    }

    return SettingView(
      appbar: SettingEntryPage.createAppBar(),
      sideBar: SettingEntryView(),
      initialView: SettingAccountView(),
    );
  }
}
