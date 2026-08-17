// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'accept_commission_work404_response_error_code.dart';
import 'accept_commission_work404_response_status.dart';

part 'accept_commission_work404_response.freezed.dart';
part 'accept_commission_work404_response.g.dart';

@Freezed()
abstract class AcceptCommissionWork404Response with _$AcceptCommissionWork404Response {
  const factory AcceptCommissionWork404Response({
    required AcceptCommissionWork404ResponseStatus status,
    required AcceptCommissionWork404ResponseErrorCode errorCode,
  }) = _AcceptCommissionWork404Response;

  factory AcceptCommissionWork404Response.fromJson(Map<String, Object?> json) =>
      _$AcceptCommissionWork404ResponseFromJson(json);
}
