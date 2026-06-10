import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';
import 'package:grimity/presentation/follow/view/follow_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowPage extends HookConsumerWidget {
  const FollowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsScaffold(
      appBar: GrimityMainTopNavigation(),
      drawer: GrimityDrawer(),
      body: FollowView(),
    );
  }

  static Future<T?> push<T>(BuildContext context) {
    if (context.isMobile) {
      return const FollowRoute().push(context);
    } else {
      final user = ProviderScope.containerOf(context).read(userAuthProvider);
      final modal = GdsModal(title: user?.name ?? '', body: FollowView());
      return modal.open(context);
    }
  }
}
