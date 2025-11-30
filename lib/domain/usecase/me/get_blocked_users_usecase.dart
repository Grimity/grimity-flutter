import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBlockedUsersUseCase extends NoParamUseCase<Result<List<User>>> {
  GetBlockedUsersUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  FutureOr<Result<List<User>>> execute() async {
    return await _meRepository.getBlockedUsers();
  }
}
