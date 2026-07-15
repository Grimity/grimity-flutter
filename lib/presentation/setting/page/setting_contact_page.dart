import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_contact_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingContactPage extends StatelessWidget {
  const SettingContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: SettingAppBar(title: '문의하기'),
      body: SettingContactView(),
    );
  }
}
