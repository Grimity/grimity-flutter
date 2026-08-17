// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'commission_notice_base_response.dart';

part 'commission_notice_response.freezed.dart';
part 'commission_notice_response.g.dart';

@Freezed()
abstract class CommissionNoticeResponse with _$CommissionNoticeResponse {
  const factory CommissionNoticeResponse({
    /// 공지가 없으면 null
    required CommissionNoticeBaseResponse? notice,
  }) = _CommissionNoticeResponse;

  factory CommissionNoticeResponse.fromJson(Map<String, Object?> json) => _$CommissionNoticeResponseFromJson(json);
}
