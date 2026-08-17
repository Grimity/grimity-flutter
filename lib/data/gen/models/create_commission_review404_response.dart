// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_review404_response_error_code.dart';
import 'create_commission_review404_response_status.dart';

part 'create_commission_review404_response.freezed.dart';
part 'create_commission_review404_response.g.dart';

@Freezed()
abstract class CreateCommissionReview404Response with _$CreateCommissionReview404Response {
  const factory CreateCommissionReview404Response({
    required CreateCommissionReview404ResponseStatus status,
    required CreateCommissionReview404ResponseErrorCode errorCode,
  }) = _CreateCommissionReview404Response;

  factory CreateCommissionReview404Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionReview404ResponseFromJson(json);
}
