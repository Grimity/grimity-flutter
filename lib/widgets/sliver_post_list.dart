import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_type.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';
import 'package:grimity/util/post_service.dart';

/// 게시글 유형과 검색 조건에 맞는 게시글 목록을 표시하는 슬리버.
class SliverPostList extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final PostService service;

  /// 게시글 목록을 불러오는 동안 표시할 임시 게시글 데이터.
  static final placeholder = PostsResponse(
    totalCount: 10,
    posts: List.generate(10, (index) {
      return .new(
        id: '',
        title: 'Placeholder',
        content: 'Placeholder',
        createdAt: .now(),
        type: .normal,
        viewCount: 0,
        commentCount: 0,
        author: .new(id: '', name: 'Placeholder', url: ''),
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    return service.sliver(
      placeholder: placeholder,
      builder: (data) {
        return SliverList.builder(
          itemCount: data.posts.length,
          itemBuilder: (context, index) {
            final post = data.posts[index];

            return GdsUserItem.post(
              type: post.type.displayName,
              chipVariant: post.type == .notice ? .primary : .assistive,
              title: post.title,
              content: post.content,
              nickname: post.author.name,
              viewCount: post.viewCount.toInt(),
              commentCount: post.commentCount.toInt(),
              createdAt: post.createdAt,
              image: post.thumbnail?.toImage(),
              onTap: () {
                // 글 상세 페이지로 이동.
                context.push(PostDetailPage(id: post.id));
              },
            );
          },
        );
      },
    );
  }
}
