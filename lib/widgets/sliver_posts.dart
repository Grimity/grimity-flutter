import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_type.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';

/// 게시글 항목을 표시하는 데 필요한 정보.
typedef SliverPost = ({
  String id,
  String nickname,
  String title,
  String content,
  String? thumbnail,
  PostType type,
  DateTime createdAt,
  int viewCount,
  int commentCount,
});

/// 인덱스에 해당하는 게시글 데이터를 반환하는 빌더.
typedef SliverPostBuilder = SliverPost Function(
  BuildContext context,
  int index,
);

/// 게시글 유형과 검색 조건에 맞는 게시글 목록을 표시하는 슬리버.
class SliverPosts extends StatelessWidget {
  const new({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final SliverPostBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final post = itemBuilder(context, index);

        return GdsUserItem.post(
          type: post.type.displayName,
          chipVariant: post.type == .notice ? .primary : .assistive,
          title: post.title,
          content: post.content,
          nickname: post.nickname,
          viewCount: post.viewCount,
          commentCount: post.commentCount,
          createdAt: post.createdAt,
          image: post.thumbnail?.toImage(),
          onTap: () {
            // 글 상세 페이지로 이동.
            context.push(PostDetailPage(id: post.id));
          },
        );
      },
    );
  }
}
