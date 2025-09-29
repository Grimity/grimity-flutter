import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

import '../../dto/search_posts_params.dart';

@injectable
class SearchPostsUseCase extends UseCase<SearchPostsParam, Result<Posts>> {
  SearchPostsUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Result<Posts>> execute(SearchPostsParam request) async {
    return await _postRepository.searchPosts(request.page, request.size, request.keyword, request.searchType);
  }
}