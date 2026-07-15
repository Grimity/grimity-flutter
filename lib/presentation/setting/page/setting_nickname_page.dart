import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_nickname_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingNicknamePage extends StatelessWidget {
  const SettingNicknamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: SettingAppBar(title: '닉네임'),
      body: SettingNicknameView(),
    );
  }
}
