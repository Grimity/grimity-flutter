// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'complete_commission_work403_response_error_code.dart';
import 'complete_commission_work403_response_status.dart';

part 'complete_commission_work403_response.freezed.dart';
part 'complete_commission_work403_response.g.dart';

@Freezed()
abstract class CompleteCommissionWork403Response with _$CompleteCommissionWork403Response {
  const factory CompleteCommissionWork403Response({
    required CompleteCommissionWork403ResponseStatus status,
    required CompleteCommissionWork403ResponseErrorCode errorCode,
  }) = _CompleteCommissionWork403Response;

  factory CompleteCommissionWork403Response.fromJson(Map<String, Object?> json) =>
      _$CompleteCommissionWork403ResponseFromJson(json);
}
