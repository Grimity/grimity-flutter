import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/data/service/post_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchPostsUseCase extends UseCase<SearchPostsRequestParam, Result<Posts>> {
  SearchPostsUseCase(this._postService);

  final PostService _postService;

  @override
  Future<Result<Posts>> execute(SearchPostsRequestParam request) async {
    return await _postService.searchPosts(
      request.page,
      request.size,
      request.keyword,
      request.searchBy,
    );
  }
}

class SearchPostsRequestParam {
  final int page;
  final int size;
  final String keyword;
  final SearchType searchBy;

  SearchPostsRequestParam({
    required this.page,
    required this.size,
    required this.keyword,
    required this.searchBy,
  });
}
