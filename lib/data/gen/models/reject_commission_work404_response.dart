// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'reject_commission_work404_response_error_code.dart';
import 'reject_commission_work404_response_status.dart';

part 'reject_commission_work404_response.freezed.dart';
part 'reject_commission_work404_response.g.dart';

@Freezed()
abstract class RejectCommissionWork404Response with _$RejectCommissionWork404Response {
  const factory RejectCommissionWork404Response({
    required RejectCommissionWork404ResponseStatus status,
    required RejectCommissionWork404ResponseErrorCode errorCode,
  }) = _RejectCommissionWork404Response;

  factory RejectCommissionWork404Response.fromJson(Map<String, Object?> json) =>
      _$RejectCommissionWork404ResponseFromJson(json);
}
