import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    if (query.isEmpty) {
      // 검색어 없으면 추천 태그
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
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final Feed feed = items[i];
                final thumb = _fullImageUrl(feed.thumbnail);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(thumb, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(feed.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                );
              },
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

  // API가 thumbnail을 "feed/UUID.webp" 같은 상대경로로 주면 풀 URL로 바꿔줍니다.
  String _fullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    // TODO: 실제 CDN/이미지 베이스 URL로 교체
    const base = 'https://image.grimity.com/';
    return '$base$path';
  }
}
