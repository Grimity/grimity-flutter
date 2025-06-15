import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserPostsUseCase extends UseCase<GetUserPostsRequestParams, Result<List<Post>>> {
  GetUserPostsUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<List<Post>>> execute(GetUserPostsRequestParams request) async {
    return await _usersRepository.getPosts(request);
  }
}
