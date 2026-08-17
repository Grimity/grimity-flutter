// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'commission_question_type.dart';

part 'commission_question_item.freezed.dart';
part 'commission_question_item.g.dart';

@Freezed()
abstract class CommissionQuestionItem with _$CommissionQuestionItem {
  const factory CommissionQuestionItem({
    required CommissionQuestionType type,
    required String title,
    required bool isRequired,

    /// SELECT 타입일 때 선택지(길이 2 이상). TEXT면 빈 배열. 순서 = 배열 index
    required List<String> options,
    dynamic description,
  }) = _CommissionQuestionItem;

  factory CommissionQuestionItem.fromJson(Map<String, Object?> json) => _$CommissionQuestionItemFromJson(json);
}
