// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'commission_notice_base_response.freezed.dart';
part 'commission_notice_base_response.g.dart';

@Freezed()
abstract class CommissionNoticeBaseResponse with _$CommissionNoticeBaseResponse {
  const factory CommissionNoticeBaseResponse({
    required String title,
    required String content,
    required DateTime updatedAt,
  }) = _CommissionNoticeBaseResponse;

  factory CommissionNoticeBaseResponse.fromJson(Map<String, Object?> json) =>
      _$CommissionNoticeBaseResponseFromJson(json);
}
