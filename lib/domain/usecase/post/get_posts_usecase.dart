import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/data/service/post_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPostsUseCase extends UseCase<GetPostsRequestParam, Result<Posts>> {
  GetPostsUseCase(this._postService);

  final PostService _postService;

  @override
  Future<Result<Posts>> execute(GetPostsRequestParam request) async {
    return await _postService.getPosts(request.page, request.size, request.type);
  }
}

class GetPostsRequestParam {
  final int page;
  final int size;
  final PostType type;

  GetPostsRequestParam({required this.page, required this.size, required this.type});
}
