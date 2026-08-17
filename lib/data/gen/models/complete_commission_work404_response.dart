// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'complete_commission_work404_response_error_code.dart';
import 'complete_commission_work404_response_status.dart';

part 'complete_commission_work404_response.freezed.dart';
part 'complete_commission_work404_response.g.dart';

@Freezed()
abstract class CompleteCommissionWork404Response with _$CompleteCommissionWork404Response {
  const factory CompleteCommissionWork404Response({
    required CompleteCommissionWork404ResponseStatus status,
    required CompleteCommissionWork404ResponseErrorCode errorCode,
  }) = _CompleteCommissionWork404Response;

  factory CompleteCommissionWork404Response.fromJson(Map<String, Object?> json) =>
      _$CompleteCommissionWork404ResponseFromJson(json);
}
