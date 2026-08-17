// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'commission_answer_item_type.dart';

part 'commission_answer_item.freezed.dart';
part 'commission_answer_item.g.dart';

@Freezed()
abstract class CommissionAnswerItem with _$CommissionAnswerItem {
  const factory CommissionAnswerItem({
    /// DIRECT 모드 필수. FORM 모드면 서버가 무시.
    CommissionAnswerItemType? type,

    /// DIRECT 모드 필수. FORM 모드면 서버가 무시.
    String? title,

    /// DIRECT 모드 선택. FORM 모드면 서버가 무시.
    dynamic description,

    /// DIRECT 모드 선택(기본 false). FORM 모드면 서버가 무시.
    bool? isRequired,

    /// DIRECT 모드 SELECT면 필수. FORM 모드면 서버가 무시.
    List<String>? options,

    /// TEXT 응답. SELECT 질문이면 null.
    dynamic text,

    /// SELECT 응답. SINGLE은 길이 1, MULTI는 길이 N. TEXT면 빈 배열.
    List<String>? selectedOptions,

    /// TEXT 답변 첨부 이미지 (0~10개). SELECT 질문이면 빈 배열/생략.
    List<String>? attachedImages,
  }) = _CommissionAnswerItem;

  factory CommissionAnswerItem.fromJson(Map<String, Object?> json) => _$CommissionAnswerItemFromJson(json);
}
