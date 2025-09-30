import 'package:flutter/material.dart';
import 'package:grimity/presentation/notification/notification_view.dart';
import 'package:grimity/presentation/notification/widget/notification_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationView(
      notificationAppBar: NotificationAppBar(),
    );
  }
}
