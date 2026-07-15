import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_profile_url_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingProfileUrlPage extends StatelessWidget {
  const SettingProfileUrlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: SettingAppBar(title: '프로필 URL'),
      body: SettingProfileUrlView(),
    );
  }
}
