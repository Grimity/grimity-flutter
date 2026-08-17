// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'upload_commission_work_result403_response_error_code.dart';
import 'upload_commission_work_result403_response_status.dart';

part 'upload_commission_work_result403_response.freezed.dart';
part 'upload_commission_work_result403_response.g.dart';

@Freezed()
abstract class UploadCommissionWorkResult403Response with _$UploadCommissionWorkResult403Response {
  const factory UploadCommissionWorkResult403Response({
    required UploadCommissionWorkResult403ResponseStatus status,
    required UploadCommissionWorkResult403ResponseErrorCode errorCode,
  }) = _UploadCommissionWorkResult403Response;

  factory UploadCommissionWorkResult403Response.fromJson(Map<String, Object?> json) =>
      _$UploadCommissionWorkResult403ResponseFromJson(json);
}
