// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'reject_commission_work403_response_error_code.dart';
import 'reject_commission_work403_response_status.dart';

part 'reject_commission_work403_response.freezed.dart';
part 'reject_commission_work403_response.g.dart';

@Freezed()
abstract class RejectCommissionWork403Response with _$RejectCommissionWork403Response {
  const factory RejectCommissionWork403Response({
    required RejectCommissionWork403ResponseStatus status,
    required RejectCommissionWork403ResponseErrorCode errorCode,
  }) = _RejectCommissionWork403Response;

  factory RejectCommissionWork403Response.fromJson(Map<String, Object?> json) =>
      _$RejectCommissionWork403ResponseFromJson(json);
}
