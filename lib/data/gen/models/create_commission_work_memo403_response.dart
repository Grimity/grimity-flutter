// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_commission_work_memo403_response_error_code.dart';
import 'create_commission_work_memo403_response_status.dart';

part 'create_commission_work_memo403_response.freezed.dart';
part 'create_commission_work_memo403_response.g.dart';

@Freezed()
abstract class CreateCommissionWorkMemo403Response with _$CreateCommissionWorkMemo403Response {
  const factory CreateCommissionWorkMemo403Response({
    required CreateCommissionWorkMemo403ResponseStatus status,
    required CreateCommissionWorkMemo403ResponseErrorCode errorCode,
  }) = _CreateCommissionWorkMemo403Response;

  factory CreateCommissionWorkMemo403Response.fromJson(Map<String, Object?> json) =>
      _$CreateCommissionWorkMemo403ResponseFromJson(json);
}
