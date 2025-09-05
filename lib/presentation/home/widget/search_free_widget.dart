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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(searchedPostsProvider);

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
                    const TextSpan(
                      text: '', // 숫자는 아래에서 동적으로
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

            // ── 리스트 (이 위젯이 페이지 바디로 단독 사용될 때) ──
            // 만약 상위가 이미 스크롤러라면:
            // 1) Expanded 제거
            // 2) 아래 ListView.builder에 shrinkWrap: true, physics: NeverScrollableScrollPhysics() 적용
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

                      // ── 제목 라인: 아이콘 + 제목 + 댓글 배지 ──
                      title: Row(
                        children: [
                          Assets.icons.home.image.svg(width: 14, height: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              p.title ?? '(제목 없음)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
                              color: Colors.white, // 안쪽 배경
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${p.commentCount ?? 0}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
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
                          Text(
                            p.content ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
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
                              Text('·',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  )),
                              const SizedBox(width: 8),

                              // 작성 시간 (몇 분 전)
                              Text(
                                timeAgo(p.createdAt), // ← createdAt: DateTime?
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
