// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_review_request_rating.dart';

part 'create_commission_review_request.freezed.dart';
part 'create_commission_review_request.g.dart';

@Freezed()
abstract class CreateCommissionReviewRequest with _$CreateCommissionReviewRequest {
  const factory CreateCommissionReviewRequest({
    /// 유저 평가: SATISFIED(만족)/NORMAL(보통)/DISSATISFIED(불만족)
    required CreateCommissionReviewRequestRating rating,

    /// 커미션 후기 (선택)
    dynamic content,
  }) = _CreateCommissionReviewRequest;

  factory CreateCommissionReviewRequest.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionReviewRequestFromJson(json);
}
