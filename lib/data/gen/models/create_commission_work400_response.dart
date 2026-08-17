// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_work400_response_error_code.dart';
import 'create_commission_work400_response_status.dart';

part 'create_commission_work400_response.freezed.dart';
part 'create_commission_work400_response.g.dart';

@Freezed()
abstract class CreateCommissionWork400Response with _$CreateCommissionWork400Response {
  const factory CreateCommissionWork400Response({
    required CreateCommissionWork400ResponseStatus status,
    required CreateCommissionWork400ResponseErrorCode errorCode,
  }) = _CreateCommissionWork400Response;

  factory CreateCommissionWork400Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionWork400ResponseFromJson(json);
}
