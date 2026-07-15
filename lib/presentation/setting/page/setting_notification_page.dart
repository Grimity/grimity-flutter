import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_notification_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingNotificationPage extends StatelessWidget {
  const SettingNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: SettingAppBar(title: '알림 설정'),
      body: SettingNotificationView(),
    );
  }
}
