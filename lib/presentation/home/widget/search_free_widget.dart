import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/post.dart' as domain;

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
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, i) {
            final p = posts[i];
            return ListTile(
              title: Text(p.title ?? '(제목 없음)'),
              subtitle: Text(p.content ?? ''),
              trailing: Text('${p.viewCount ?? 0}뷰'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('게시글 로딩 실패: $e')),
    );
  }
}
