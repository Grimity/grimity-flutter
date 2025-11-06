import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/widget/grimity_reaction.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_check_box.dart';

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
    return GrimityGesture(
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
                    child: GrimityCheckBox(value: selected, onChanged: (_) => onToggleSelected.call()),
                  ),
                ],
              ),
            ),
          ),
          const Gap(8),
          Flexible(child: Text(feed.title, style: AppTypeface.label2, maxLines: 1, overflow: TextOverflow.ellipsis)),
          const Gap(2),
          GrimityReaction.nameLikeView(
            name: feed.author?.name ?? authorName,
            likeCount: feed.likeCount,
            viewCount: feed.viewCount,
          ),
        ],
      ),
    );
  }
}
