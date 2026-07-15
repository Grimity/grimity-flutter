import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_entry_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingEntryPage extends StatelessWidget {
  const SettingEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: createAppBar(),
      body: SettingEntryView(),
    );
  }

  static Widget createAppBar() {
    return SettingAppBar(title: '설정');
  }
}
