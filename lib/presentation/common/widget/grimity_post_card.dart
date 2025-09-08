import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';

class GrimityPostCard extends StatelessWidget {
  final Post post;
  final bool showPostType;
  final String? keyword;

  const GrimityPostCard({super.key, required this.post, this.showPostType = false, this.keyword});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PostDetailRoute(id: post.id).push(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showPostType && post.type != null) ...[
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(color: AppColor.primary1, borderRadius: BorderRadius.circular(99)),
                child: Text(
                  PostType.valueToName(post.type!),
                  style: AppTypeface.caption3.copyWith(color: AppColor.primary2),
                ),
              ),
              Gap(6),
            ],
            Row(
              children: [
                if (post.thumbnail != null) ...[Assets.icons.home.image.svg(width: 16, height: 16), const Gap(6)],
                Flexible(
                  child: Text.rich(
                    buildHighlightedSpan(
                      text: post.title,
                      keyword: keyword,
                      normal: AppTypeface.label1.copyWith(color: AppColor.gray800),
                    ),
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
            Text.rich(
              buildHighlightedSpan(
                text: post.content,
                keyword: keyword,
                normal: AppTypeface.label3.copyWith(color: AppColor.gray700),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(4),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (post.author != null) {
                      ProfileRoute(url: post.author!.url).push(context);
                    }
                  },
                  child: Text(
                    post.author?.name ?? '작성자 정보 없음',
                    style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                  ),
                ),
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
      ),
    );
  }

  InlineSpan buildHighlightedSpan({required String text, String? keyword, required TextStyle normal}) {
    if (keyword == null || keyword.isEmpty) {
      return TextSpan(text: text, style: normal);
    }

    final kw = keyword.trim();
    final reg = RegExp(RegExp.escape(kw), caseSensitive: false);
    final spans = <TextSpan>[];
    int start = 0;

    for (final m in reg.allMatches(text)) {
      if (m.start > start) {
        spans.add(TextSpan(text: text.substring(start, m.start), style: normal));
      }
      spans.add(TextSpan(text: text.substring(m.start, m.end), style: normal.copyWith(color: AppColor.main)));
      start = m.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normal));
    }

    return TextSpan(children: spans, style: normal);
  }
}
