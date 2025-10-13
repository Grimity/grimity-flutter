import 'package:flutter/material.dart';
import 'package:grimity/presentation/storage/view/storage_like_feed_view.dart';
import 'package:grimity/presentation/storage/view/storage_save_feed_view.dart';
import 'package:grimity/presentation/storage/view/storage_save_post_view.dart';

class StorageBodyView extends StatelessWidget {
  const StorageBodyView({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [StorageLikeFeedView(), StorageSaveFeedView(), StorageSavePostView()],
    );
  }
}
