// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_response.freezed.dart';
part 'error_response.g.dart';

@Freezed()
abstract class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required num statusCode,

    /// 유효성 검사 실패 시 문자열 배열로 내려온다
    required dynamic message,
    String? error,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, Object?> json) => _$ErrorResponseFromJson(json);
}
