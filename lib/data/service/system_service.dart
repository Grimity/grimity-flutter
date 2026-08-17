import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_common_mapper.dart';
import 'package:grimity/domain/entity/app_version.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SystemService {
  final RestClient _client;

  SystemService(this._client);

  Future<Result<void>> healthCheck() async {
    try {
      await _client.app.appHealthCheck();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<AppVersion>> getAppVersion() async {
    try {
      final response = await _client.app.appGetAppversion();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
