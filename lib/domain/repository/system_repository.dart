import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/app_version.dart';

abstract class SystemRepository {
  Future<Result<void>> healthCheck();

  Future<Result<AppVersion>> getAppVersion();
}
