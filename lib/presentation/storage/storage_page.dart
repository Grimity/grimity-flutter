import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/storage_view.dart';
import 'package:grimity/presentation/storage/view/storage_body_view.dart';
import 'package:grimity/presentation/storage/widget/storage_app_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoragePage extends HookConsumerWidget {
  const StoragePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: StorageTabType.values.length);

    return StorageView(
      storageAppBar: StorageAppBar(tabController: tabController),
      storageBodyView: StorageBodyView(tabController: tabController),
    );
  }
}
