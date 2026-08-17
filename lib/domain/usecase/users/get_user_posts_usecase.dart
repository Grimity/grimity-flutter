import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserPostsUseCase extends UseCase<GetUserPostsRequestParams, Result<List<Post>>> {
  GetUserPostsUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<List<Post>>> execute(GetUserPostsRequestParams request) async {
    return await _usersService.getPosts(request);
  }
}
