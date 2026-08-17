// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'complete_commission_work409_response_error_code.dart';
import 'complete_commission_work409_response_status.dart';

part 'complete_commission_work409_response.freezed.dart';
part 'complete_commission_work409_response.g.dart';

@Freezed()
abstract class CompleteCommissionWork409Response with _$CompleteCommissionWork409Response {
  const factory CompleteCommissionWork409Response({
    required CompleteCommissionWork409ResponseStatus status,
    required CompleteCommissionWork409ResponseErrorCode errorCode,
  }) = _CompleteCommissionWork409Response;

  factory CompleteCommissionWork409Response.fromJson(Map<String, Object?> json) =>
      _$CompleteCommissionWork409ResponseFromJson(json);
}
