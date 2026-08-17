import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/data/service/post_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPostDetailUseCase extends UseCase<String, Result<Post>> {
  GetPostDetailUseCase(this._postService);

  final PostService _postService;

  @override
  Future<Result<Post>> execute(String request) async {
    return await _postService.getPostDetail(request);
  }
}
