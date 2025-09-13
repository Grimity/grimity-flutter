import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/app/config/app_color.dart';

class GrimitySelectableImageFeed extends StatelessWidget {
  const GrimitySelectableImageFeed({
    super.key,
    required this.feed,
    this.authorName,
    required this.selected,
    required this.onToggleSelected,
  });

  final Feed feed;
  final String? authorName;
  final bool selected;
  final VoidCallback onToggleSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleSelected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF000000).withValues(alpha: 0.4),
                border: Border.all(color: selected ? AppColor.main : AppColor.gray00.withValues(alpha: 0.5), width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  GrimityImage.big(imageUrl: feed.thumbnail ?? ''),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 24,
                      height: 24,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: selected ? AppColor.main : AppColor.gray00,
                        border: selected ? null : Border.all(color: AppColor.gray400, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Assets.icons.common.check.svg(
                        colorFilter: ColorFilter.mode(selected ? AppColor.gray00 : AppColor.gray300, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(8),
          Flexible(child: Text(feed.title, style: AppTypeface.label2, maxLines: 1, overflow: TextOverflow.ellipsis)),
          const Gap(2),
          Row(
            children: [
              Text(
                feed.author?.name ?? authorName ?? '작성자 정보 없음',
                style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
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
