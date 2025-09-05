import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';
import 'package:grimity/presentation/home/widget/category_tags_widget.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'empty_state_widget.dart';
import 'search_free_widget.dart';
import 'search_user_widget.dart';

class NoRelatedResult extends StatelessWidget {
  final String keyword;
  const NoRelatedResult({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget();
  }
}

class SearchContentWidget extends ConsumerWidget {
  const SearchContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);
    final query = DrawingHooks.useSearchQuery(ref).trim();

    // 검색어 없으면 추천 태그 노출
    if (query.isEmpty) {
      return CategoryTagsWidget();
    }

    switch (selectedTab) {
    // 0: 그림(피드)
      case 0:
        final asyncFeeds = ref.watch(searchedFeedsProvider);
        return asyncFeeds.when(
          data: (Feeds f) {
            final items = f.feeds;
            if (items.isEmpty) return NoRelatedResult(keyword: query);

            final total = f.totalCount ?? items.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 결과 개수
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '검색결과 ',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        TextSpan(
                          text: '$total',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: '건',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                ),
                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final feed = items[i];
                      final thumb = _fullImageUrl(feed.thumbnail);

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 썸네일
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    (thumb.isEmpty)
                                        ? Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.image, color: Colors.grey[400]),
                                    )
                                        : Image.network(thumb, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Assets.icons.home.heart.svg(
                                      width: 18,
                                      height: 18,
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // 제목
                            Text(
                              feed.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 작성자 + 하트/뷰
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    feed.author?.name ?? '익명',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // 하트
                                Assets.icons.home.heart.svg(width: 14, height: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '${feed.likeCount ?? 0}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(width: 6),
                                // 조회수(눈)
                                Assets.icons.home.eye.svg(width: 14, height: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '${feed.viewCount ?? 0}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('피드 로딩 실패: $e')),
        );

    // 1: 유저
      case 1:
        return const SearchUserWidget();

    // 2: 자유게시판
      case 2:
        return const SearchFreeWidget();

      default:
        return NoRelatedResult(keyword: query);
    }
  }

  /// API가 thumbnail을 "feed/UUID.webp" 같은 상대경로로 주면 풀 URL로 변환
  String _fullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    // 실제 CDN/이미지 베이스 URL에 맞춰 변경하세요.
    const base = 'https://image.grimity.com/';
    return '$base$path';
  }
}
