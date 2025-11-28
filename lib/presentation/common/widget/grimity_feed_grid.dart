import 'package:flutter/material.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';

class GrimityFeedGrid extends StatelessWidget {
  const GrimityFeedGrid({
    super.key,
    required this.feeds,
    this.isSliver = false,
    this.keyword,
    this.authorName,
  });

  final List<Feed> feeds;
  final bool isSliver;
  final String? keyword;
  final String? authorName;

  const GrimityFeedGrid.sliver({
    super.key,
    required this.feeds,
    this.keyword,
    this.authorName,
  }) : isSliver = true;

  @override
  Widget build(BuildContext context) {
    final delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 20,
      childAspectRatio: _calculateAspectRatio(context),
    );

    if (isSliver) {
      return SliverGrid.builder(
        gridDelegate: delegate,
        itemCount: feeds.length,
        itemBuilder: (context, index) {
          final feed = feeds[index];
          return GrimityImageFeed(
            feed: feed,
            keyword: keyword,
            authorName: authorName,
          );
        },
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: delegate,
      itemCount: feeds.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final feed = feeds[index];
        return GrimityImageFeed(
          feed: feed,
          keyword: keyword,
          authorName: authorName,
        );
      },
    );
  }

  // GridView 내 아이템 비율
  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // 전체 화면 너비
    final horizontalPadding = 32; // 좌우 여백 합
    final crossAxisSpacing = 12; // 아이템 간격
    final availableWidth = screenWidth - horizontalPadding; // 실제 카드들이 들어갈 총 공간
    final itemWidth = (availableWidth - crossAxisSpacing) / 2; // 아이템 하나 당 너비

    // 카드 하단에 들어갈 텍스트 높이 계산
    final textAreaHeight = 8 + (14 * 1.4) + 2 + (12 * 1.4);

    // 한 칸당 아이템 너비 / (한 칸당 아이템 너비 + 텍스트 영역 높이)
    return itemWidth / (itemWidth + textAreaHeight);
  }
}
