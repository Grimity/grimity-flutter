// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cancel_commission_work409_response_error_code.dart';
import 'cancel_commission_work409_response_status.dart';

part 'cancel_commission_work409_response.freezed.dart';
part 'cancel_commission_work409_response.g.dart';

@Freezed()
abstract class CancelCommissionWork409Response with _$CancelCommissionWork409Response {
  const factory CancelCommissionWork409Response({
    required CancelCommissionWork409ResponseStatus status,
    required CancelCommissionWork409ResponseErrorCode errorCode,
  }) = _CancelCommissionWork409Response;

  factory CancelCommissionWork409Response.fromJson(Map<String, Object?> json) =>
      _$CancelCommissionWork409ResponseFromJson(json);
}
