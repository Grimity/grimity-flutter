import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/block/view/blocked_users_view.dart';
import 'package:grimity/presentation/block/widget/blocked_users_app_bar.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: BlockedUsersAppBar(),
      body: BlockedUsersView(),
    );
  }
}
