import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key, required this.notificationAppBar, required this.notificationBody});

  final PreferredSizeWidget notificationAppBar;
  final Widget notificationBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: notificationAppBar, body: notificationBody);
  }
}
