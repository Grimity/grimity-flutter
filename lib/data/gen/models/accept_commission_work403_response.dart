// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'accept_commission_work403_response_error_code.dart';
import 'accept_commission_work403_response_status.dart';

part 'accept_commission_work403_response.freezed.dart';
part 'accept_commission_work403_response.g.dart';

@Freezed()
abstract class AcceptCommissionWork403Response with _$AcceptCommissionWork403Response {
  const factory AcceptCommissionWork403Response({
    required AcceptCommissionWork403ResponseStatus status,
    required AcceptCommissionWork403ResponseErrorCode errorCode,
  }) = _AcceptCommissionWork403Response;

  factory AcceptCommissionWork403Response.fromJson(Map<String, Object?> json) =>
      _$AcceptCommissionWork403ResponseFromJson(json);
}
