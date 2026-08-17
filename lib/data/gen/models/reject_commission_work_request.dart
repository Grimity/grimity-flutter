// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reject_commission_work_request.freezed.dart';
part 'reject_commission_work_request.g.dart';

@Freezed()
abstract class RejectCommissionWorkRequest with _$RejectCommissionWorkRequest {
  const factory RejectCommissionWorkRequest({
    /// 거절 사유 (선택)
    dynamic reason,
  }) = _RejectCommissionWorkRequest;

  factory RejectCommissionWorkRequest.fromJson(Map<String, Object?> json) =>
      _$RejectCommissionWorkRequestFromJson(json);
}
