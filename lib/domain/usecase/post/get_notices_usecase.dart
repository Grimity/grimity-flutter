import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNoticesUseCase extends NoParamUseCase<Result<List<Post>>> {
  GetNoticesUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Result<List<Post>>> execute() async {
    return await _postRepository.getNotices();
  }
}
