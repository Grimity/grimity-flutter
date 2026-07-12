import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';
import 'package:grimity/presentation/storage/storage_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoragePage extends HookConsumerWidget {
  const StoragePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);

    return GdsScaffold(
      appBar: GrimityTitleTopNavigation(),
      drawer: GrimityDrawer(),
      body: StorageView(tabController: tabController),
    );
  }
}
