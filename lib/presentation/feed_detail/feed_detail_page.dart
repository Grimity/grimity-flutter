import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/feed_detail/feed_detail_view.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedDetailPage extends ConsumerWidget {
  final String feedId;

  const FeedDetailPage({super.key, required this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedDetailDataProvider(feedId));

    return feedAsync.maybeWhen(
      data: (feed) {
        feed ??= Feed.empty();

        return FeedDetailView(feed: feed);
      },
      orElse: () {
        return Skeletonizer(child: FeedDetailView(feed: Feed.empty()));
      },
    );
  }
}
