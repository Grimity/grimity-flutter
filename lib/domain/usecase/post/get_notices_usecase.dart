import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/data/service/post_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNoticesUseCase extends NoParamUseCase<Result<List<Post>>> {
  GetNoticesUseCase(this._postService);

  final PostService _postService;

  @override
  Future<Result<List<Post>>> execute() async {
    return await _postService.getNotices();
  }
}
