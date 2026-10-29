import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

/// 공지와 함께 게시글 유형과 검색 조건에 맞는 목록을 조회하는 서비스.
class PostService extends Service<PostsResponse> {
  new({
    required this.type,
    required this.keyword,
    required this.searchBy,
    this.showNotices = true,
  });

  final PostTypeFilter type;
  final String keyword;
  final PostSearchBy searchBy;

  /// 공지 게시글을 목록 상단에 표시할지 여부.
  final bool showNotices;

  // 첫 페이지부터 조회.
  int page = 1;

  /// 검색어가 2자 이상이면 검색하고, 그 외에는 게시글 목록을 조회합니다.
  Service<PostsResponse> createService() {
    if (keyword.length > 1) {
      return GetPostsSearch(
        type: type,
        page: page,
        size: 10,
        keyword: keyword,
        searchBy: searchBy,
      );
    }

    return GetPosts(type: type, page: page, size: 10);
  }

  @override
  Future<PostsResponse> fetchData() async {
    if (!showNotices || page != 1 || keyword.length > 1 || type == .notice) {
      return createService().request();
    }

    // 공지와 게시글을 동시에 조회.
    final (notices, response) = await (
      GetPostsNotices().request(),
      createService().request(),
    ).wait;

    // 응답 결과 합치기.
    return PostsResponse(
      totalCount: response.totalCount,
      posts: [...notices, ...response.posts],
    );
  }

  /// 지정한 페이지의 게시글 목록을 조회합니다.
  void nextPage(int index) {
    page = index;
    refresh();
  }

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
}
