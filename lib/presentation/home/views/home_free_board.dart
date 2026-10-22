import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/home/widgets/home_section.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';

/// 홈 화면에서 자유게시판의 최신 글을 목록으로 표시하는 위젯.
class HomeFreeBoard extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final GetPosts service;

  /// 최신 글을 불러오는 동안 표시할 임시 게시글 데이터.
  static final placeholder = PostsResponse(
    totalCount: 3,
    posts: List.generate(3, (_) {
      return .new(
        id: '',
        title: 'Placeholder',
        content: '',
        createdAt: .now(),
        type: .normal,
        viewCount: 0,
        commentCount: 0,
        author: .new(id: '', name: 'Placeholder', url: ''),
      );
    }),
  );

  /// 전체 유형의 최신 게시글 3개를 조회하는 서비스를 생성합니다.
  static GetPosts createService() => .new(
    page: 1,
    size: 3,
    type: .all,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HomeSection(
        header: .new(
          title: '자유게시판 최신 글',
          onMore: () {
            // 자유게시판 페이지로 이동
            NavigationPage.moveTo(context, 3);
          },
        ),
        child: service.builder(
          placeholder: placeholder,
          builder: (data) {
            return Column(
              mainAxisSize: .min,
              children: data.posts.builder((post) {
                return buildPost(context, post);
              }),
            );
          },
        ),
      ),
    );
  }

  /// 각 자유 게시글의 제목과 관련 정보를 표시하는 빌더.
  Widget buildPost(BuildContext context, PostWithAuthorResponse post) {
    return GdsUserItem.post(
      type: post.type.key,
      title: post.title,
      image: post.thumbnail?.toImage(),
      createdAt: post.createdAt,
      viewCount: post.viewCount.toInt(),
      commentCount: post.commentCount.toInt(),
      showImage: true,
      onTap: () {
        // 글 상세 페이지로 이동.
        context.push(PostDetailPage(id: post.id));
      },
    );
  }
}
