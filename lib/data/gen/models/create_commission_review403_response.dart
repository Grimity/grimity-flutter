// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_review403_response_error_code.dart';
import 'create_commission_review403_response_status.dart';

part 'create_commission_review403_response.freezed.dart';
part 'create_commission_review403_response.g.dart';

@Freezed()
abstract class CreateCommissionReview403Response with _$CreateCommissionReview403Response {
  const factory CreateCommissionReview403Response({
    required CreateCommissionReview403ResponseStatus status,
    required CreateCommissionReview403ResponseErrorCode errorCode,
  }) = _CreateCommissionReview403Response;

  factory CreateCommissionReview403Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionReview403ResponseFromJson(json);
}
