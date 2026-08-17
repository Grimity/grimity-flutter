// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_base_response.freezed.dart';
part 'user_base_response.g.dart';

@Freezed()
abstract class UserBaseResponse with _$UserBaseResponse {
  const factory UserBaseResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,
  }) = _UserBaseResponse;

  factory UserBaseResponse.fromJson(Map<String, Object?> json) => _$UserBaseResponseFromJson(json);
}
