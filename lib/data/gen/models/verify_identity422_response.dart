// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'verify_identity422_response_error_code.dart';
import 'verify_identity422_response_status.dart';

part 'verify_identity422_response.freezed.dart';
part 'verify_identity422_response.g.dart';

@Freezed()
abstract class VerifyIdentity422Response with _$VerifyIdentity422Response {
  const factory VerifyIdentity422Response({
    required VerifyIdentity422ResponseStatus status,
    required VerifyIdentity422ResponseErrorCode errorCode,
  }) = _VerifyIdentity422Response;

  factory VerifyIdentity422Response.fromJson(Map<String, Object?> json) => _$VerifyIdentity422ResponseFromJson(json);
}
