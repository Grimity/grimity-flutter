// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'upload_commission_work_result404_response_error_code.dart';
import 'upload_commission_work_result404_response_status.dart';

part 'upload_commission_work_result404_response.freezed.dart';
part 'upload_commission_work_result404_response.g.dart';

@Freezed()
abstract class UploadCommissionWorkResult404Response with _$UploadCommissionWorkResult404Response {
  const factory UploadCommissionWorkResult404Response({
    required UploadCommissionWorkResult404ResponseStatus status,
    required UploadCommissionWorkResult404ResponseErrorCode errorCode,
  }) = _UploadCommissionWorkResult404Response;

  factory UploadCommissionWorkResult404Response.fromJson(Map<String, Object?> json) =>
      _$UploadCommissionWorkResult404ResponseFromJson(json);
}
