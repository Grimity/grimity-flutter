import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/post.dart' as domain;

import '../../../gen/assets.gen.dart';
import 'empty_state_widget.dart';

class SearchFreeWidget extends ConsumerWidget {
  const SearchFreeWidget({Key? key}) : super(key: key);

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
            // 결과 개수
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '검색결과 ${posts.length}건',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),

            // 리스트
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
                      // 제목 영역: 아이콘 + 제목
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
                        ],
                      ),

                      // 본문 + 메타
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

                              // 댓글수
                              const Icon(Icons.mode_comment, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${p.commentCount ?? 0}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),

                              const SizedBox(width: 12),

                              // 조회수
                              const Icon(Icons.visibility, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${p.viewCount ?? 0}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
