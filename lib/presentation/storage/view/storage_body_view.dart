import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/provider/storage_tab_type_provider.dart';
import 'package:grimity/presentation/storage/view/storage_like_feed_view.dart';
import 'package:grimity/presentation/storage/view/storage_save_feed_view.dart';
import 'package:grimity/presentation/storage/view/storage_save_post_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StorageBodyView extends HookConsumerWidget {
  const StorageBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    ref.listen<StorageTabType>(storageTabProvider, (prev, next) {
      final currentPage = pageController.page?.round() ?? pageController.initialPage;
      if (pageController.hasClients && next.index != currentPage) {
        pageController.jumpToPage(next.index);
      }
    });

    return PageView(
      controller: pageController,
      onPageChanged: (index) => ref.read(storageTabProvider.notifier).changeTab(StorageTabType.values[index]),
      children: [StorageLikeFeedView(), StorageSaveFeedView(), StorageSavePostView()],
    );
  }
}
