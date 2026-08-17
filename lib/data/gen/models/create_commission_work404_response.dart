// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_work404_response_error_code.dart';
import 'create_commission_work404_response_status.dart';

part 'create_commission_work404_response.freezed.dart';
part 'create_commission_work404_response.g.dart';

@Freezed()
abstract class CreateCommissionWork404Response with _$CreateCommissionWork404Response {
  const factory CreateCommissionWork404Response({
    required CreateCommissionWork404ResponseStatus status,
    required CreateCommissionWork404ResponseErrorCode errorCode,
  }) = _CreateCommissionWork404Response;

  factory CreateCommissionWork404Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionWork404ResponseFromJson(json);
}
