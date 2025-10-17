import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_highlight_text_span.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';

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
    return GestureDetector(
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (feed.author != null) {
                    ProfileRoute(url: feed.author!.url).go(context);
                  }
                },
                child: Text(
                  feed.author?.name ?? authorName ?? '작성자 정보 없음',
                  style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                ),
              ),
              GrimityGrayCircle(),
              Assets.icons.common.like.svg(width: 16, height: 16),
              const Gap(4),
              Text(feed.likeCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
              GrimityGrayCircle(),
              Assets.icons.common.view.svg(width: 16, height: 16),
              const Gap(4),
              Text(feed.viewCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
            ],
          ),
        ],
      ),
    );
  }
}
