// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_name_request.freezed.dart';
part 'check_name_request.g.dart';

@Freezed()
abstract class CheckNameRequest with _$CheckNameRequest {
  const factory CheckNameRequest({
    required String name,
  }) = _CheckNameRequest;

  factory CheckNameRequest.fromJson(Map<String, Object?> json) => _$CheckNameRequestFromJson(json);
}
