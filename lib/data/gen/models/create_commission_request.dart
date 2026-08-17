// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'commission_question_item.dart';

part 'create_commission_request.freezed.dart';
part 'create_commission_request.g.dart';

@Freezed()
abstract class CreateCommissionRequest with _$CreateCommissionRequest {
  const factory CreateCommissionRequest({
    required String title,

    /// HTML 문자열
    required String description,

    /// 1000원 단위, 0(무료) 가능
    required num price,

    /// 작업 기간(일)
    required num workDays,

    /// 수정 횟수
    required num revisionCount,
    required List<String> images,

    /// images 중 대표로 지정한 imageName
    required String thumbnail,

    /// 없으면 빈 배열
    required List<String> tags,
    required List<CommissionQuestionItem> questions,

    /// 공개 여부 (공개=true, 비공개=false)
    required bool isPublic,

    /// HTML 문자열 (선택)
    String? additionalCondition,
  }) = _CreateCommissionRequest;

  factory CreateCommissionRequest.fromJson(Map<String, Object?> json) => _$CreateCommissionRequestFromJson(json);
}
