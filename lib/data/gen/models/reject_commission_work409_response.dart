// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'reject_commission_work409_response_error_code.dart';
import 'reject_commission_work409_response_status.dart';

part 'reject_commission_work409_response.freezed.dart';
part 'reject_commission_work409_response.g.dart';

@Freezed()
abstract class RejectCommissionWork409Response with _$RejectCommissionWork409Response {
  const factory RejectCommissionWork409Response({
    required RejectCommissionWork409ResponseStatus status,
    required RejectCommissionWork409ResponseErrorCode errorCode,
  }) = _RejectCommissionWork409Response;

  factory RejectCommissionWork409Response.fromJson(Map<String, Object?> json) =>
      _$RejectCommissionWork409ResponseFromJson(json);
}
