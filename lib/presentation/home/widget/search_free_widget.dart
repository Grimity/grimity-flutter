import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/post.dart' as domain;

import '../../../gen/assets.gen.dart';
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

  // 하이라이트 유틸: terms 에 매칭되는 부분만 초록색
  TextSpan _highlight(
      String text,
      List<String> terms, {
        TextStyle? normalStyle,
        TextStyle? highlightStyle,
      }) {
    if (text.isEmpty || terms.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final cleaned = terms
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length)); // 긴 키워드 우선

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(searchedPostsProvider);

    // 검색어 → 키워드 배열
    final query = ref.watch(searchQueryProvider).trim();
    final terms = query.isEmpty
        ? const <String>[]
        : query.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

    return asyncPosts.when(
      data: (List<domain.Post> posts) {
        if (posts.isEmpty) {
          return EmptyStateWidget();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 결과 개수 ─────────────────────────────────────
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
                      text: '${posts.length}',
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
              ),
            ),

            // ── 리스트 ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  final p = posts[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),

                      // ── 제목 라인: 아이콘 + 제목(하이라이트) + 댓글 배지 ──
                      title: Row(
                        children: [
                          Assets.icons.home.image.svg(width: 14, height: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: _highlight(
                                p.title ?? '(제목 없음)',
                                terms,
                                normalStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                highlightStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${p.commentCount ?? 0}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red, // 필요하면 회색으로 바꿔도 됨
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── 본문 + 메타 ──
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: _highlight(
                              p.content ?? '',
                              terms,
                              normalStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.2,
                              ),
                              highlightStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // 작성자
                              Expanded(
                                child: Text(
                                  p.author?.name ?? '익명',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // 구분 점
                              Text(
                                '·',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // 작성 시간 (몇 분 전)
                              Text(
                                timeAgo(p.createdAt), // createdAt: DateTime?
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // 조회수
                              const Icon(Icons.visibility,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${p.viewCount ?? 0}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
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
