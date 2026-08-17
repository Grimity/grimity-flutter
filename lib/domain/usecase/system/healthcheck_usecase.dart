import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/system_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class HealthCheckUseCase extends NoParamUseCase<Result<void>> {
  HealthCheckUseCase(this._systemService);

  final SystemService _systemService;

  @override
  FutureOr<Result<void>> execute() async {
    return await _systemService.healthCheck();
  }
}
