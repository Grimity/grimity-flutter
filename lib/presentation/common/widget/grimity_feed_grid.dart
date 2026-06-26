import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';

class GrimityFeedGrid extends StatelessWidget {
  const GrimityFeedGrid({
    super.key,
    required this.feeds,
    this.isSliver = false,
    this.keyword,
    this.padding = EdgeInsets.zero,
    this.authorName,
  });

  final List<Feed> feeds;
  final bool isSliver;
  final String? keyword;
  final String? authorName;
  final EdgeInsets padding;

  const GrimityFeedGrid.sliver({
    super.key,
    required this.feeds,
    this.keyword,
    this.padding = EdgeInsets.zero,
    this.authorName,
  }) : isSliver = true;

  @override
  Widget build(BuildContext context) {
    if (isSliver) {
      return SliverPadding(
        padding: padding,
        sliver: SliverDynamicHeightGridView(
          crossAxisCount: context.feedRowCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 20,
          itemCount: feeds.length,
          builder: (context, index) {
            final feed = feeds[index];

            return GrimityImageFeed(
              feed: feed,
              keyword: keyword,
              authorName: authorName ?? feed.author?.name,
            );
          },
        ),
      );
    }

    return Padding(
      padding: padding,
      child: DynamicHeightGridView(
        crossAxisCount: context.feedRowCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        shrinkWrap: true,
        itemCount: feeds.length,
        physics: const NeverScrollableScrollPhysics(),
        builder: (context, index) {
          final feed = feeds[index];
          return GrimityImageFeed(
            feed: feed,
            keyword: keyword,
            authorName: authorName ?? feed.author?.name,
          );
        },
      ),
    );
  }
}
