// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_type.dart';

part 'my_post_response.freezed.dart';
part 'my_post_response.g.dart';

@Freezed()
abstract class MyPostResponse with _$MyPostResponse {
  const factory MyPostResponse({
    required String id,
    required String title,
    required String content,

    /// FULL URL
    required String? thumbnail,
    required DateTime createdAt,
    required PostType type,
    required num commentCount,
    required num viewCount,
  }) = _MyPostResponse;

  factory MyPostResponse.fromJson(Map<String, Object?> json) => _$MyPostResponseFromJson(json);
}
