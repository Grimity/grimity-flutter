import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserFeedsUseCase extends UseCase<GetUserFeedsRequestParams, Result<Feeds>> {
  GetUserFeedsUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<Feeds>> execute(GetUserFeedsRequestParams request) async {
    return await _usersService.getFeeds(request);
  }
}
