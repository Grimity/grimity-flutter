// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_review409_response_error_code.dart';
import 'create_commission_review409_response_status.dart';

part 'create_commission_review409_response.freezed.dart';
part 'create_commission_review409_response.g.dart';

@Freezed()
abstract class CreateCommissionReview409Response with _$CreateCommissionReview409Response {
  const factory CreateCommissionReview409Response({
    required CreateCommissionReview409ResponseStatus status,
    required CreateCommissionReview409ResponseErrorCode errorCode,
  }) = _CreateCommissionReview409Response;

  factory CreateCommissionReview409Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionReview409ResponseFromJson(json);
}
