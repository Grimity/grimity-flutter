// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_link_request.dart';

part 'update_user_request.freezed.dart';
part 'update_user_request.g.dart';

@Freezed()
abstract class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({
    required String name,
    required String url,

    /// 없으면 빈 문자열 주세요
    required String description,
    required List<UpdateLinkRequest>? links,
  }) = _UpdateUserRequest;

  factory UpdateUserRequest.fromJson(Map<String, Object?> json) => _$UpdateUserRequestFromJson(json);
}
