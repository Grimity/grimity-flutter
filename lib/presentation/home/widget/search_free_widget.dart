import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/post.dart' as domain;
import 'package:grimity/presentation/common/widget/grimity_post_card.dart';
import '../../../app/config/app_color.dart';
import '../../../app/config/app_typeface.dart';
import '../../common/util/text_highlighter.dart';
import 'empty_state_widget.dart';

class SearchFreeWidget extends ConsumerWidget {
  const SearchFreeWidget({Key? key}) : super(key: key);

  // "n초/분/시간/일 전" 표기 (null-safe)
  String timeAgo(DateTime? createdAt) {
    if (createdAt == null) return '-';
    final created = createdAt.toLocal();
    final now = DateTime.now();
    final diff = now.difference(created);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}초 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      final m = created.month.toString().padLeft(2, '0');
      final d = created.day.toString().padLeft(2, '0');
      return '${created.year}-$m-$d';
    }
  }

  // 검색어 → 키워드 배열
  List<String> _terms(String q) =>
      q.trim().isEmpty ? const [] : q.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

  // 정확도 점수(간단 가중치): 제목>본문>작성자
  int _accuracyScorePost(domain.Post p, List<String> terms) {
    if (terms.isEmpty) return 0;
    int score = 0;
    final t = (p.title ?? '').toLowerCase();
    final c = (p.content ?? '').toLowerCase();
    final a = (p.author?.name ?? '').toLowerCase();

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
  int _popularScorePost(domain.Post p) {
    final like = p.likeCount ?? 0;
    final comment = p.commentCount ?? 0;
    final view = p.viewCount ?? 0;
    return 3 * like + 5 * comment + 1 * view;
  }

  // 라벨
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

  // 드롭다운(“검색결과 N건” 오른쪽)
  Widget _sortDropdown(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(searchSortProvider);

    // Flutter 구버전 호환: inkWellTheme 미사용, 잉크색만 덮어쓰기
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
        items: SearchSort.values
            .map((s) => DropdownMenuItem<SearchSort>(
          value: s,
          child: Text(
            _sortLabel(s),
            style: const TextStyle(fontSize: 13),
          ),
        ))
            .toList(),
        elevation: 2,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(12),
        style: const TextStyle(color: Colors.black87),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        dropdownColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(searchedPostsProvider);

    // 검색어 → 키워드 배열
    final query = ref.watch(searchQueryProvider).trim();
    final terms = _terms(query);

    // 정렬 상태
    final sort = ref.watch(searchSortProvider);

    return asyncPosts.when(
      data: (List<domain.Post> posts) {
        if (posts.isEmpty) {
          return EmptyStateWidget();
        }

        // 프론트 단 정렬(현재 페이지 기준)
        final sorted = [...posts]..sort((a, b) {
          switch (sort) {
            case SearchSort.recent:
              final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final cmp = bd.compareTo(ad); // desc
              if (cmp != 0) return cmp;
              return _popularScorePost(b).compareTo(_popularScorePost(a)); // tie-breaker

            case SearchSort.popular:
              final cmp = _popularScorePost(b).compareTo(_popularScorePost(a));
              if (cmp != 0) return cmp;
              final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bd.compareTo(ad); // tie-breaker

            case SearchSort.accuracy:
            default:
              final cmp = _accuracyScorePost(b, terms).compareTo(_accuracyScorePost(a, terms));
              if (cmp != 0) return cmp;
              final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bd.compareTo(ad); // tie-breaker
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 결과 개수 + 정렬 드롭다운 ──────────────────────
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
                            text: '${sorted.length}',
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
                  _sortDropdown(context, ref),
                ],
              ),
            ),

            // ── 리스트 ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sorted.length,
                itemBuilder: (context, i) {
                  final p = sorted[i];
                  return GrimityPostCard(
                    post: p,
                    titleSpan: TextHighlighter.highlight(
                      p.title ?? '',
                      terms,
                      normalStyle: AppTypeface.label1.copyWith(color: AppColor.gray800),
                      highlightStyle: AppTypeface.label1.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    contentSpan: TextHighlighter.highlight(
                      p.content ?? '',
                      terms,
                      normalStyle: AppTypeface.label3.copyWith(color: AppColor.gray700),
                      highlightStyle: AppTypeface.label3.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
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
      error: (e, _) => Center(child: Text('게시글 로딩 실패: $e')),
    );
  }
}
