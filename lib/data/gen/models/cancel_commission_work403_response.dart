// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cancel_commission_work403_response_error_code.dart';
import 'cancel_commission_work403_response_status.dart';

part 'cancel_commission_work403_response.freezed.dart';
part 'cancel_commission_work403_response.g.dart';

@Freezed()
abstract class CancelCommissionWork403Response with _$CancelCommissionWork403Response {
  const factory CancelCommissionWork403Response({
    required CancelCommissionWork403ResponseStatus status,
    required CancelCommissionWork403ResponseErrorCode errorCode,
  }) = _CancelCommissionWork403Response;

  factory CancelCommissionWork403Response.fromJson(Map<String, Object?> json) =>
      _$CancelCommissionWork403ResponseFromJson(json);
}
