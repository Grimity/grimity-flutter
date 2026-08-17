// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'upload_commission_work_result409_response_error_code.dart';
import 'upload_commission_work_result409_response_status.dart';

part 'upload_commission_work_result409_response.freezed.dart';
part 'upload_commission_work_result409_response.g.dart';

@Freezed()
abstract class UploadCommissionWorkResult409Response with _$UploadCommissionWorkResult409Response {
  const factory UploadCommissionWorkResult409Response({
    required UploadCommissionWorkResult409ResponseStatus status,
    required UploadCommissionWorkResult409ResponseErrorCode errorCode,
  }) = _UploadCommissionWorkResult409Response;

  factory UploadCommissionWorkResult409Response.fromJson(Map<String, Object?> json) =>
      _$UploadCommissionWorkResult409ResponseFromJson(json);
}
