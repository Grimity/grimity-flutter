import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPostDetailUseCase extends UseCase<String, Result<Post>> {
  GetPostDetailUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Result<Post>> execute(String request) async {
    return await _postRepository.getPostDetail(request);
  }
}
