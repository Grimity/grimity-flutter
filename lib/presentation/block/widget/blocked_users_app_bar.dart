import 'package:flutter/widgets.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';

class BlockedUsersAppBar extends StatelessWidget {
  const BlockedUsersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GrimityTitleTopNavigation(title: '차단 목록');
  }
}
