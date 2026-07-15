import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_account_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingAccountPage extends StatelessWidget {
  const SettingAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: SettingAppBar(title: '내 계정'),
      body: SettingAccountView(),
    );
  }
}
