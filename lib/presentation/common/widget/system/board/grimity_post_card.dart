import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_highlight_text_span.dart';
import 'package:grimity/presentation/common/widget/grimity_reaction.dart';
import 'package:grimity/presentation/common/widget/system/chip/grimity_chip.dart';

/// 게시글 위젯
class GrimityPostCard extends StatelessWidget {
  final Post post;
  final bool showPostType;
  final String? keyword;

  const GrimityPostCard({super.key, required this.post, this.showPostType = false, this.keyword});

  @override
  Widget build(BuildContext context) {
    return GrimityGesture(
      onTap: () => PostDetailRoute(id: post.id).push(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showPostType && post.type != null) ...[_buildPostTypeChip(post.type!), Gap(6)],
            Row(
              children: [
                if (post.thumbnail != null) ...[Assets.icons.home.image.svg(width: 16, height: 16), const Gap(6)],
                Flexible(
                  child: GrimityHighlightTextSpan(
                    text: post.title,
                    keyword: keyword,
                    normal: AppTypeface.label1.copyWith(color: AppColor.gray800),
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
            GrimityHighlightTextSpan(
              text: post.content,
              keyword: keyword,
              normal: AppTypeface.label3.copyWith(color: AppColor.gray700),
            ),
            const Gap(4),
            GrimityReaction.nameDateView(
              name: post.author?.name,
              createdAt: post.createdAt,
              viewCount: post.viewCount,
              onNameTap: () {
                if (post.author != null) {
                  ProfileRoute(url: post.author!.url).go(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostTypeChip(String type) {
    final postType = PostType.fromString(type);
    return postType.isLightChip ? GrimityChip.light(postType.typeName) : GrimityChip.dark(postType.typeName);
  }
}
