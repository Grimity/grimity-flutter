import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';

class GrimityPostCard extends StatelessWidget {
  final Post post;
  final InlineSpan? titleSpan;
  final InlineSpan? contentSpan;

  const GrimityPostCard({
    super.key,
    required this.post,
    this.titleSpan,
    this.contentSpan,
  });

  @override
  Widget build(BuildContext context) {

    final String title = post.title ?? '';
    final String content = post.content ?? '';
    final String author = post.author?.name ?? '작성자 정보 없음';
    final int comments = post.commentCount ?? 0;
    final int views = post.viewCount ?? 0;
    final DateTime createdAt = post.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (post.thumbnail != null) ...[
                Assets.icons.home.image.svg(width: 16, height: 16),
                const Gap(6),
              ],
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: (titleSpan != null)
                          ? RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: titleSpan!,
                      )
                          : Text(
                        title,
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
                        '$comments',
                        style: AppTypeface.caption1.copyWith(color: AppColor.accentRed),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(4),
          (contentSpan != null)
              ? RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: contentSpan!,
          )
              : Text(
            content,
            style: AppTypeface.label3.copyWith(color: AppColor.gray700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Row(
            children: [
              Text(author ?? '작성자 정보 없음', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
              GrimityGrayCircle(),
              Text(createdAt.toRelativeTime(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
              GrimityGrayCircle(),
              Assets.icons.common.view.svg(width: 16, height: 16),
              const Gap(2),
              Text(views.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
            ],
          ),
        ],
      ),
    );
  }
}
