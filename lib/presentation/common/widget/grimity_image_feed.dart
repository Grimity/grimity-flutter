import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_highlight_text_span.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/presentation/common/widget/grimity_reaction.dart';

class GrimityImageFeed extends StatelessWidget {
  const GrimityImageFeed({
    super.key,
    required this.feed,
    this.authorName,
    this.index,
    this.keyword,
    this.onToggleLike,
    this.onToggleSave,
  });

  final Feed feed;
  final String? authorName;
  final int? index;
  final String? keyword;
  final VoidCallback? onToggleLike;
  final VoidCallback? onToggleSave;

  @override
  Widget build(BuildContext context) {
    return GrimityGesture(
      onTap: () => FeedDetailRoute(id: feed.id).push(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: GrimityImage.big(
              imageUrl: feed.thumbnail ?? '',
              index: index,
              isLike: feed.isLike,
              onToggleLike: onToggleLike,
              isSave: feed.isSave,
              onToggleSave: onToggleSave,
            ),
          ),
          const Gap(8),
          Flexible(child: GrimityHighlightTextSpan(text: feed.title, keyword: keyword, normal: AppTypeface.label2)),
          const Gap(2),
          GrimityReaction.nameLikeView(
            name: feed.author?.name ?? authorName,
            likeCount: feed.likeCount,
            viewCount: feed.viewCount,
            onNameTap: () {
              if (feed.author != null) {
                ProfileRoute(url: feed.author!.url).go(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
