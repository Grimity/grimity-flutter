import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_util_bar.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';

class FeedUtilBar extends ConsumerWidget {
  final Feed feed;

  const FeedUtilBar({super.key, required this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLike = feed.isLike ?? false;
    final isSave = feed.isSave ?? false;

    return GrimityUtilBar(
      isLike: isLike,
      isSave: isSave,
      likeCount: feed.likeCount ?? 0,
      commentCount: feed.commentCount ?? 0,
      shareUrl: '${AppConfig.apiUrl}feeds/${feed.id}',
      onLikeTap: () => ref.read(feedDetailDataProvider(feed.id).notifier).toggleLikeFeed(feed.id, !isLike),
      onSaveTap: () => ref.read(feedDetailDataProvider(feed.id).notifier).toggleSaveFeed(feed.id, !isSave),
    );
  }
}
