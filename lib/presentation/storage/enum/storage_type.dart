import 'package:flutter/widgets.dart';
import 'package:grimity/presentation/storage/view/storage_like_feed_view.dart';
import 'package:grimity/presentation/storage/view/storage_save_feed_view.dart';
import 'package:grimity/presentation/storage/view/storage_save_post_view.dart';

enum StorageType {
  likeFeed('좋아요한 그림'),
  saveFeed('저장한 그림'),
  savePost('저장한 글');

  final String label;
  const StorageType(this.label);

  Widget buildView() => switch (this) {
    StorageType.likeFeed => StorageLikeFeedView(),
    StorageType.saveFeed => StorageSaveFeedView(),
    StorageType.savePost => StorageSavePostView(),
  };
}
