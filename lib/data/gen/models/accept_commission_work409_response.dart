// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'accept_commission_work409_response_error_code.dart';
import 'accept_commission_work409_response_status.dart';

part 'accept_commission_work409_response.freezed.dart';
part 'accept_commission_work409_response.g.dart';

@Freezed()
abstract class AcceptCommissionWork409Response with _$AcceptCommissionWork409Response {
  const factory AcceptCommissionWork409Response({
    required AcceptCommissionWork409ResponseStatus status,
    required AcceptCommissionWork409ResponseErrorCode errorCode,
  }) = _AcceptCommissionWork409Response;

  factory AcceptCommissionWork409Response.fromJson(Map<String, Object?> json) =>
      _$AcceptCommissionWork409ResponseFromJson(json);
}
