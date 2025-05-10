import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPostsUseCase extends UseCase<GetPostsRequestParam, Result<List<Post>>> {
  GetPostsUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Result<List<Post>>> execute(GetPostsRequestParam request) async {
    return await _postRepository.getPosts(request.page, request.size, request.type);
  }
}

class GetPostsRequestParam {
  final int page;
  final int size;
  final PostType type;

  GetPostsRequestParam({required this.page, required this.size, required this.type});
}
