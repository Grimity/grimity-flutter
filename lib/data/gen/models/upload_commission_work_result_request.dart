// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_commission_work_result_request.freezed.dart';
part 'upload_commission_work_result_request.g.dart';

@Freezed()
abstract class UploadCommissionWorkResultRequest with _$UploadCommissionWorkResultRequest {
  const factory UploadCommissionWorkResultRequest({
    /// 작업물 이미지 (1~20개)
    required List<String> images,

    /// 최종 작업물 여부
    required bool isFinal,
  }) = _UploadCommissionWorkResultRequest;

  factory UploadCommissionWorkResultRequest.fromJson(Map<String, Object?> json) =>
      _$UploadCommissionWorkResultRequestFromJson(json);
}
