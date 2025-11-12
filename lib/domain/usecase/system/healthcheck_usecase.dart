import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/system_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class HealthCheckUseCase extends NoParamUseCase<Result<void>> {
  HealthCheckUseCase(this._systemRepository);

  final SystemRepository _systemRepository;

  @override
  FutureOr<Result<void>> execute() async {
    return await _systemRepository.healthCheck();
  }
}
