import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';

class GrimityPostFeed extends StatelessWidget {
  const GrimityPostFeed({super.key, required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      separatorBuilder: (context, index) {
        return Divider(color: AppColor.gray300, height: 1, thickness: 1);
      },
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (posts[index].thumbnail != null) ...[
                    Assets.icons.home.image.svg(width: 16, height: 16),
                    const Gap(6),
                  ],
                  Flexible(
                    child: Text(
                      posts[index].title,
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
                      posts[index].commentCount.toString(),
                      style: AppTypeface.caption1.copyWith(color: AppColor.accentRed),
                    ),
                  ),
                ],
              ),
              const Gap(4),
              Text(
                posts[index].content,
                style: AppTypeface.label3.copyWith(color: AppColor.gray700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(4),
              Row(
                children: [
                  Text(
                    posts[index].author?.name ?? '작성자 정보 없음',
                    style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                  ),
                  GrimityGrayCircle(),
                  Text(
                    posts[index].createdAt.toRelativeTime(),
                    style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                  ),
                  GrimityGrayCircle(),
                  Assets.icons.home.view.svg(width: 16, height: 16),
                  const Gap(2),
                  Text(
                    posts[index].viewCount.toString(),
                    style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
