import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyFollowersUseCase extends UseCase<GetMyFollowersRequestParam, Result<Users>> {
  GetMyFollowersUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<Users>> execute(GetMyFollowersRequestParam request) async {
    return await _meService.getMyFollowers(request.size, request.cursor);
  }
}

class GetMyFollowersRequestParam {
  final int? size;
  final String? cursor;

  GetMyFollowersRequestParam({this.size, this.cursor});
}
