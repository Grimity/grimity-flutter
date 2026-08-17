import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBlockedUsersUseCase extends NoParamUseCase<Result<List<User>>> {
  GetBlockedUsersUseCase(this._meService);

  final MeService _meService;

  @override
  FutureOr<Result<List<User>>> execute() async {
    return await _meService.getBlockedUsers();
  }
}
