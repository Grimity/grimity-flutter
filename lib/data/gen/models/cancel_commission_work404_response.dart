// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cancel_commission_work404_response_error_code.dart';
import 'cancel_commission_work404_response_status.dart';

part 'cancel_commission_work404_response.freezed.dart';
part 'cancel_commission_work404_response.g.dart';

@Freezed()
abstract class CancelCommissionWork404Response with _$CancelCommissionWork404Response {
  const factory CancelCommissionWork404Response({
    required CancelCommissionWork404ResponseStatus status,
    required CancelCommissionWork404ResponseErrorCode errorCode,
  }) = _CancelCommissionWork404Response;

  factory CancelCommissionWork404Response.fromJson(Map<String, Object?> json) =>
      _$CancelCommissionWork404ResponseFromJson(json);
}
