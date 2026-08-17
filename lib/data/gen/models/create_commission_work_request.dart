// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'commission_answer_item.dart';

part 'create_commission_work_request.freezed.dart';
part 'create_commission_work_request.g.dart';

@Freezed()
abstract class CreateCommissionWorkRequest with _$CreateCommissionWorkRequest {
  const factory CreateCommissionWorkRequest({
    /// 수신자(작가) userId
    required String authorId,

    /// 레퍼런스 이미지 (0~10개)
    required List<String> referenceImages,

    /// 있으면 FORM 모드(폼 신청), 없으면 DIRECT 모드(직접 의뢰)
    dynamic commissionId,

    /// FORM 모드: 배열 인덱스 = 질문 order, text/selectedOptions만 사용(메타는 서버가 무시). DIRECT 모드: type/title 포함한 완전한 답변 아이템.
    List<CommissionAnswerItem>? answers,
  }) = _CreateCommissionWorkRequest;

  factory CreateCommissionWorkRequest.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionWorkRequestFromJson(json);
}
