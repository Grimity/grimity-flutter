// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version_response.freezed.dart';
part 'app_version_response.g.dart';

@Freezed()
abstract class AppVersionResponse with _$AppVersionResponse {
  const factory AppVersionResponse({
    /// 시맨틱 버전 스펙을 따릅니다
    required String version,
    required DateTime createdAt,
  }) = _AppVersionResponse;

  factory AppVersionResponse.fromJson(Map<String, Object?> json) => _$AppVersionResponseFromJson(json);
}
