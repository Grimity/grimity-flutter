import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';
import 'package:grimity/presentation/home/widget/category_tags_widget.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/presentation/common/util/text_highlighter.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/domain/entity/feed.dart';
import '../../../app/config/app_typeface.dart';
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

  String _fullImageUrl(String? path) {
    if ((path ?? '').isEmpty) return '';
    if (path!.startsWith('http')) return path;
    const base = 'https://image.grimity.com/';
    return '$base$path';
  }

  List<String> _terms(String q) =>
      q.trim().isEmpty ? const [] : q.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

  int _accuracyScoreFeed(Feed f, List<String> terms) {
    if (terms.isEmpty) return 0;
    int score = 0;
    final t = (f.title ?? '').toLowerCase();
    final c = (f.content ?? '').toLowerCase();
    final a = (f.author?.name ?? '').toLowerCase();

    for (final term in terms) {
      final q = term.toLowerCase();
      if (t == q) score += 400;
      if (t.startsWith(q)) score += 150;
      if (t.contains(q)) score += 100;

      if (c.startsWith(q)) score += 60;
      if (c.contains(q)) score += 40;

      if (a.startsWith(q)) score += 35;
      if (a.contains(q)) score += 20;
    }
    return score;
  }

  // 인기 점수(간단 가중치)
  int _popularScoreFeed(Feed f) {
    final like = f.likeCount ?? 0;
    final view = f.viewCount ?? 0;
    return 3 * like + 1 * view;
  }

  String _sortLabel(SearchSort s) {
    switch (s) {
      case SearchSort.accuracy:
        return '정확도순';
      case SearchSort.recent:
        return '최신순';
      case SearchSort.popular:
        return '인기순';
    }
  }

  // ⬅︎ BuildContext도 함께 받도록!
  Widget _sortDropdown(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(searchSortProvider);

    final themed = Theme.of(context).copyWith(
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
      hoverColor: Colors.black12,
      focusColor: Colors.black12,
    );

    return Theme(
      data: themed,
      child: DropdownButton<SearchSort>(
        value: sort,
        onChanged: (v) {
          if (v == null) return;
          ref.read(searchSortProvider.notifier).state = v;
        },
        items: SearchSort.values.map((s) {
          final label = switch (s) {
            SearchSort.accuracy => '정확도순',
            SearchSort.recent   => '최신순',
            SearchSort.popular  => '인기순',
          };
          return DropdownMenuItem<SearchSort>(
            value: s,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
        dropdownColor: Colors.white,                 // 메뉴 배경
        iconEnabledColor: Colors.black87,           // 아이콘 색
        style: const TextStyle(color: Colors.black87, fontSize: 13),
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);
    final query = DrawingHooks.useSearchQuery(ref).trim();

    // 🔎 검색어 → 키워드 배열
    final terms = _terms(query);

    // 검색어 없으면 추천 태그 노출
    if (query.isEmpty) {
      return CategoryTagsWidget();
    }

    switch (selectedTab) {
    // 0: 그림(피드)
      case 0:
        final asyncFeeds = ref.watch(searchedFeedsProvider);
        final sort = ref.watch(searchSortProvider);

        return asyncFeeds.when(
          data: (Feeds f) {
            final items = f.feeds;
            if (items.isEmpty) return NoRelatedResult(keyword: query);

            final total = f.totalCount ?? items.length;

            // ⬇️ 클라이언트 정렬 (임시)
            final sorted = [...items]..sort((a, b) {
              switch (sort) {
                case SearchSort.recent:
                  final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  final cmp = bd.compareTo(ad); // desc
                  if (cmp != 0) return cmp;
                  // tie-breaker
                  return (b.likeCount ?? 0).compareTo(a.likeCount ?? 0);

                case SearchSort.popular:
                  final cmp = _popularScoreFeed(b).compareTo(_popularScoreFeed(a));
                  if (cmp != 0) return cmp;
                  final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  return bd.compareTo(ad);

                case SearchSort.accuracy:
                default:
                  final cmp = _accuracyScoreFeed(b, terms).compareTo(_accuracyScoreFeed(a, terms));
                  if (cmp != 0) return cmp;
                  final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  return bd.compareTo(ad);
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 결과 개수 + 정렬 드롭다운
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '검색결과 ',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              TextSpan(
                                text: '$total',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '건',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // ▼ 드롭다운
                      _sortDropdown(context, ref),
                    ],
                  ),
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
                    itemCount: sorted.length, // ⬅️ 정렬된 데이터 사용
                    itemBuilder: (context, i) {
                      final feed = sorted[i]; // ⬅️ 정렬된 데이터 사용
                      final thumb = _fullImageUrl(feed.thumbnail);

                      // Grid itemBuilder 안
                      return GrimityImageFeed(
                        feed: feed,
                        titleSpan: TextHighlighter.highlight(
                          feed.title ?? '',
                          terms,
                          normalStyle: AppTypeface.label2,
                          highlightStyle: AppTypeface.label2.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
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
}
