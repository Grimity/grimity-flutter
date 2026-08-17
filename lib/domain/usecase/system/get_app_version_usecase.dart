import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/app_version.dart';
import 'package:grimity/data/service/system_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAppVersionUseCase extends NoParamUseCase<Result<AppVersion>> {
  GetAppVersionUseCase(this._systemService);

  final SystemService _systemService;

  @override
  FutureOr<Result<AppVersion>> execute() async {
    return await _systemService.getAppVersion();
  }
}
