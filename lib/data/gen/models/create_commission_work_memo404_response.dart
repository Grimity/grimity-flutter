// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_work_memo404_response_error_code.dart';
import 'create_commission_work_memo404_response_status.dart';

part 'create_commission_work_memo404_response.freezed.dart';
part 'create_commission_work_memo404_response.g.dart';

@Freezed()
abstract class CreateCommissionWorkMemo404Response with _$CreateCommissionWorkMemo404Response {
  const factory CreateCommissionWorkMemo404Response({
    required CreateCommissionWorkMemo404ResponseStatus status,
    required CreateCommissionWorkMemo404ResponseErrorCode errorCode,
  }) = _CreateCommissionWorkMemo404Response;

  factory CreateCommissionWorkMemo404Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionWorkMemo404ResponseFromJson(json);
}
