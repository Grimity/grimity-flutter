import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyFollowingsUseCase extends UseCase<GetMyFollowingsRequestParam, Result<Users>> {
  GetMyFollowingsUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<Users>> execute(GetMyFollowingsRequestParam request) async {
    return await _meService.getMyFollowings(request.size, request.cursor);
  }
}

class GetMyFollowingsRequestParam {
  final int? size;
  final String? cursor;

  GetMyFollowingsRequestParam({this.size, this.cursor});
}
