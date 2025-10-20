import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';

class GrimityReaction extends StatelessWidget {
  const GrimityReaction._({
    this.name,
    this.createdAt,
    this.likeCount,
    this.viewCount,
    this.followerCount,
    this.onNameTap,
  });

  final String? name;
  final DateTime? createdAt;
  final int? likeCount;
  final int? viewCount;
  final int? followerCount;
  final VoidCallback? onNameTap;

  factory GrimityReaction.nameLikeView({
    required String? name,
    required int? likeCount,
    required int? viewCount,
    VoidCallback? onNameTap,
  }) => GrimityReaction._(
    name: name ?? '작성자 정보 없음',
    likeCount: likeCount ?? 0,
    viewCount: viewCount ?? 0,
    onNameTap: onNameTap,
  );

  factory GrimityReaction.nameDateView({
    required String? name,
    required DateTime? createdAt,
    required int? viewCount,
    VoidCallback? onNameTap,
  }) => GrimityReaction._(
    name: name ?? '작성자 정보 없음',
    createdAt: createdAt ?? DateTime.now(),
    viewCount: viewCount ?? 0,
    onNameTap: onNameTap,
  );

  factory GrimityReaction.dateLikeView({
    required DateTime? createdAt,
    required int? likeCount,
    required int? viewCount,
  }) => GrimityReaction._(createdAt: createdAt ?? DateTime.now(), likeCount: likeCount ?? 0, viewCount: viewCount ?? 0);

  factory GrimityReaction.follower({required int? followerCount}) =>
      GrimityReaction._(followerCount: followerCount ?? 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (name != null) ...[
          Flexible(
            child: GestureDetector(
              onTap: onNameTap,
              child: Text(
                name!,
                style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GrimityGrayCircle(),
        ],
        if (createdAt != null) ...[
          Text(createdAt!.toRelativeTime(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
          GrimityGrayCircle(),
        ],
        if (likeCount != null) ...[
          Assets.icons.common.like.svg(width: 16, height: 16),
          Gap(2),
          Text(likeCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
          GrimityGrayCircle(),
        ],
        if (viewCount != null) ...[
          Assets.icons.common.view.svg(width: 16, height: 16),
          Gap(2),
          Text(viewCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
        ],
        if (followerCount != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '팔로워 ', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                TextSpan(text: followerCount.toString(), style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
              ],
            ),
          ),
      ],
    );
  }
}
