import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/search/pages/search_page.dart';

/// 피드의 제목과 본문, 간략한 통계 및 태그를 표시하는 위젯.
class FeedDetailContent extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.content,
    required this.likeCount,
    required this.viewCount,
    required this.createdAt,
    required this.tags,
  });

  final String title;
  final String content;
  final int likeCount;
  final int viewCount;
  final DateTime createdAt;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          // 제목 표시
          GdsText(
            title,
            color: .textGrayBold,
            style: context.whenDevice(
              mobile: .title3,
              tablet: .title2,
            ),
          ),
          context.whenDevice(
            mobile: const Gap(8),
            tablet: const Gap(20),
          ),

          // 본문 표시
          GdsText(
            content,
            color: .textGrayBold,
            style: context.whenDevice(
              mobile: .body2R,
              tablet: .body1R,
            ),
          ),
          const Gap(16),

          // 좋아요 수, 조회 수와 작성일 표시.
          GdsUserInfo.normal(
            likeCount: likeCount,
            viewCount: viewCount,
            date: createdAt,
          ),

          // 태그 목록 표시
          if (tags.isNotEmpty) ...[
            const Gap(24),

            Wrap(
              alignment: .start,
              runAlignment: .start,
              spacing: 8,
              runSpacing: 8,
              children: tags.builder((tag) {
                return GdsTag(
                  size: context.whenDevice(mobile: .xs, tablet: .md),
                  label: tag,
                  onTap: () {
                    // 선택한 태그로 검색 페이지 이동.
                    context.push(SearchPage(initialKeyword: tag));
                  },
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
