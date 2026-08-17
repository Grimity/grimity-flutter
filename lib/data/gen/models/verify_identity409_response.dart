// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'verify_identity409_response_error_code.dart';
import 'verify_identity409_response_status.dart';

part 'verify_identity409_response.freezed.dart';
part 'verify_identity409_response.g.dart';

@Freezed()
abstract class VerifyIdentity409Response with _$VerifyIdentity409Response {
  const factory VerifyIdentity409Response({
    required VerifyIdentity409ResponseStatus status,
    required VerifyIdentity409ResponseErrorCode errorCode,
  }) = _VerifyIdentity409Response;

  factory VerifyIdentity409Response.fromJson(Map<String, Object?> json) => _$VerifyIdentity409ResponseFromJson(json);
}
