import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../app/base/result.dart';
import '../../../app/base/use_case.dart';
import '../../dto/search_posts_param.dart';
import '../../repository/post_repository.dart';
import 'package:grimity/domain/entity/post.dart';

@injectable
class SearchPostsUseCase extends UseCase<SearchPostsParam, Result<List<Post>>> {
  SearchPostsUseCase(this._repo);
  final PostRepository _repo;

  @override
  FutureOr<Result<List<Post>>> execute(SearchPostsParam input) {
    // async 붙이지 말고, repo가 주는 Future<Result<...>>를 그대로 반환
    return _repo.searchPosts(
      page: input.page,
      size: input.size,
      keyword: input.keyword,
      searchBy: input.searchBy,
    );
  }
}
