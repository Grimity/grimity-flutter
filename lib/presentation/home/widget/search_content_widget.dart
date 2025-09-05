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

  String _fullImageUrl(String? path) {
    if ((path ?? '').isEmpty) return '';
    if (path!.startsWith('http')) return path;
    const base = 'https://image.grimity.com/'; // 실제 CDN 베이스에 맞춰 수정
    return '$base$path';
  }

  // 🖍️ 하이라이트 유틸: terms 에 매칭되는 부분만 초록색
  TextSpan _highlight(
      String text,
      List<String> terms, {
        TextStyle? normalStyle,
        TextStyle? highlightStyle,
      }) {
    if (text.isEmpty || terms.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    // 빈 키워드 제거 + 긴 단어 우선(겹침 최소화)
    final cleaned = terms
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    if (cleaned.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final pattern = cleaned.map(RegExp.escape).join('|');
    final reg = RegExp('($pattern)', caseSensitive: false);

    final spans = <TextSpan>[];
    int start = 0;

    for (final m in reg.allMatches(text)) {
      if (m.start > start) {
        spans.add(TextSpan(text: text.substring(start, m.start), style: normalStyle));
      }
      spans.add(TextSpan(text: text.substring(m.start, m.end), style: highlightStyle));
      start = m.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }
    return TextSpan(children: spans);
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
      // 잉크(눌림/호버) 오버레이 색을 회색으로
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
      hoverColor: Colors.black12,
      focusColor: Colors.black12,

      // (선택) 잉크 효과 자체를 없애고 싶다면 아래 주석 해제
      // splashFactory: NoSplash.splashFactory,
      // splashColor: Colors.transparent,
      // highlightColor: Colors.transparent,
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
                                    thumb.isEmpty
                                        ? Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.image, color: Colors.grey[400]),
                                    )
                                        : Image.network(
                                      thumb,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
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

                            // 제목 (키워드 하이라이트 적용)
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: _highlight(
                                feed.title ?? '',
                                terms,
                                normalStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                highlightStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            // 작성자 + 하트/뷰
                            Row(
                              children: [
                                Expanded(
                                  // 필요하면 작성자에도 하이라이트 적용 가능:
                                  // RichText(text: _highlight(feed.author?.name ?? '익명', terms, ...))
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
}
