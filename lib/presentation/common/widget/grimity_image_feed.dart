import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';

class GrimityImageFeed extends StatelessWidget {
  const GrimityImageFeed({super.key, required this.feed, this.index, this.onToggleLike, this.onToggleSave});

  final Feed feed;
  final int? index;
  final VoidCallback? onToggleLike;
  final VoidCallback? onToggleSave;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(child: Text(feed.title, style: AppTypeface.label2, maxLines: 1, overflow: TextOverflow.ellipsis)),
        const Gap(2),
        Row(
          children: [
            Text(feed.author?.name ?? '작성자 정보 없음', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
            GrimityGrayCircle(),
            Assets.icons.home.like.svg(width: 16, height: 16),
            const Gap(4),
            Text(feed.likeCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
            GrimityGrayCircle(),
            Assets.icons.home.view.svg(width: 16, height: 16),
            const Gap(4),
            Text(feed.viewCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
          ],
        ),
      ],
    );
  }
}
