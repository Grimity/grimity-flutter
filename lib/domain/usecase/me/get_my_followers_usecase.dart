import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyFollowersUseCase extends UseCase<GetMyFollowersRequestParam, Result<Users>> {
  GetMyFollowersUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<Users>> execute(GetMyFollowersRequestParam request) async {
    return await _meRepository.getMyFollowers(request.size, request.cursor);
  }
}

class GetMyFollowersRequestParam {
  final int? size;
  final String? cursor;

  GetMyFollowersRequestParam({this.size, this.cursor});
}
