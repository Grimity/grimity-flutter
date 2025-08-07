import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:grimity/presentation/following_feed/view/following_feed_empty_view.dart';
import 'package:grimity/presentation/following_feed/widget/following_feed_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FollowingFeedListView extends ConsumerWidget {
  const FollowingFeedListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingFeedAsync = ref.watch(followingFeedDataProvider);

    return followingFeedAsync.maybeWhen(
      data: (feeds) {
        final feedList = feeds.feeds;

        return feedList.isEmpty ? FollowingFeedEmptyView() : _FeedListView(feeds: feedList);
      },
      orElse: () {
        return Skeletonizer(child: _FeedListView(feeds: Feed.emptyList));
      },
    );
  }
}

class _FeedListView extends StatelessWidget {
  const _FeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (context, index) => FollowingFeedCard(feed: feeds[index]),
      separatorBuilder: (context, index) => Divider(height: 1, color: AppColor.gray300),
      itemCount: feeds.length,
    );
  }
}
