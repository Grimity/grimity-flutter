import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';

/// 게시글 위젯
class GrimityPostCard extends StatelessWidget {
  final Post post;

  const GrimityPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (post.thumbnail != null) ...[Assets.icons.home.image.svg(width: 16, height: 16), const Gap(6)],
              Flexible(
                child: Text(
                  post.title,
                  style: AppTypeface.label1.copyWith(color: AppColor.gray800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Gap(4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColor.secandary2.withValues(alpha: 0.1),
                  border: Border.all(color: AppColor.gray300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  post.commentCount.toString(),
                  style: AppTypeface.caption1.copyWith(color: AppColor.accentRed),
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            post.content,
            style: AppTypeface.label3.copyWith(color: AppColor.gray700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Row(
            children: [
              Text(post.author?.name ?? '작성자 정보 없음', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
              GrimityGrayCircle(),
              Text(post.createdAt.toRelativeTime(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
              GrimityGrayCircle(),
              Assets.icons.common.view.svg(width: 16, height: 16),
              const Gap(2),
              Text(post.viewCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
            ],
          ),
        ],
      ),
    );
  }
}
