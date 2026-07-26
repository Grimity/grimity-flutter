import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/page/setting_entry_page.dart';
import 'package:grimity/presentation/setting/setting_view.dart';
import 'package:grimity/presentation/setting/view/setting_account_view.dart';
import 'package:grimity/presentation/setting/view/setting_entry_view.dart';

class SettingPage extends HookWidget {
  const SettingPage({
    super.key,
    this.initialPage,
    this.initialView,
  });

  final Widget? initialPage;
  final Widget? initialView;

  @override
  Widget build(BuildContext context) {
    assert(initialPage != null || initialView == null);

    if (context.isMobile) {
      return initialPage ?? SettingEntryPage();
    }

    return SettingView(
      appbar: SettingEntryPage.createAppBar(),
      sideBar: SettingEntryView(),
      initialView: initialView ?? SettingAccountView(),
    );
  }
}
