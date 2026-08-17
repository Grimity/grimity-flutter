// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_commission_work_memo_request.freezed.dart';
part 'create_commission_work_memo_request.g.dart';

@Freezed()
abstract class CreateCommissionWorkMemoRequest with _$CreateCommissionWorkMemoRequest {
  const factory CreateCommissionWorkMemoRequest({
    /// 작업 메모 내용
    required String content,
  }) = _CreateCommissionWorkMemoRequest;

  factory CreateCommissionWorkMemoRequest.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionWorkMemoRequestFromJson(json);
}
