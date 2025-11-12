import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/app_version.dart';

part 'app_version_response.freezed.dart';

part 'app_version_response.g.dart';

@Freezed(copyWith: false)
abstract class AppVersionResponse with _$AppVersionResponse {
  const factory AppVersionResponse({
    required String version,
    required DateTime createdAt,
  }) = _AppVersionResponse;

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) => _$AppVersionResponseFromJson(json);
}

extension AppVersionResponseX on AppVersionResponse {
  AppVersion toEntity() {
    return AppVersion(
      version: version,
      createdAt: createdAt,
    );
  }
}
