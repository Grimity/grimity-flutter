import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/system_api.dart';
import 'package:grimity/data/model/system/app_version_response.dart';
import 'package:grimity/domain/entity/app_version.dart';
import 'package:grimity/domain/repository/system_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SystemRepository)
class SystemRepositoryImpl extends SystemRepository {
  final SystemAPI _systemAPI;

  SystemRepositoryImpl(this._systemAPI);

  @override
  Future<Result<void>> healthCheck() async {
    try {
      await _systemAPI.healthCheck();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<AppVersion>> getAppVersion() async {
    try {
      final response = await _systemAPI.getAppVersion();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
