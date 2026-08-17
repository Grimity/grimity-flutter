// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_commission_notice_request.freezed.dart';
part 'upsert_commission_notice_request.g.dart';

@Freezed()
abstract class UpsertCommissionNoticeRequest with _$UpsertCommissionNoticeRequest {
  const factory UpsertCommissionNoticeRequest({
    /// 공지 제목
    required String title,

    /// 공지 내용
    required String content,
  }) = _UpsertCommissionNoticeRequest;

  factory UpsertCommissionNoticeRequest.fromJson(Map<String, Object?> json) =>
      _$UpsertCommissionNoticeRequestFromJson(json);
}
