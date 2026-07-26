import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';
import 'package:grimity/presentation/follow/view/follow_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowPage extends HookConsumerWidget {
  const FollowPage({
    super.key,
    required this.tabIndex,
  });

  final int tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsScaffold(
      appBar: GrimityMainTopNavigation(),
      drawer: GrimityDrawer(),
      body: FollowView(tabIndex: tabIndex),
    );
  }

  static Future<T?> push<T>(BuildContext context, int tabIndex) {
    if (context.isMobile) {
      return FollowRoute(tabIndex).push(context);
    } else {
      final user = ProviderScope.containerOf(context).read(userAuthProvider);
      final view = FollowView(tabIndex: tabIndex);
      final modal = GdsModal(title: user?.name ?? '', body: view);
      return modal.open(context);
    }
  }

  static Future<T?> pushReplace<T>(BuildContext context, int tabIndex) {
    context.pop();
    return push(context, tabIndex);
  }
}
