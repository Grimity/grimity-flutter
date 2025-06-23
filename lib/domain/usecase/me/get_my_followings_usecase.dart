import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyFollowingsUseCase extends UseCase<GetMyFollowingsRequestParam, Result<Users>> {
  GetMyFollowingsUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<Users>> execute(GetMyFollowingsRequestParam request) async {
    return await _meRepository.getMyFollowings(request.size, request.cursor);
  }
}

class GetMyFollowingsRequestParam {
  final int? size;
  final String? cursor;

  GetMyFollowingsRequestParam({this.size, this.cursor});
}
