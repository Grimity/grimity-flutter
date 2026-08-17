// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta_response.freezed.dart';
part 'user_meta_response.g.dart';

@Freezed()
abstract class UserMetaResponse with _$UserMetaResponse {
  const factory UserMetaResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,

    /// not null인데 공백은 허용
    required String description,
  }) = _UserMetaResponse;

  factory UserMetaResponse.fromJson(Map<String, Object?> json) => _$UserMetaResponseFromJson(json);
}
