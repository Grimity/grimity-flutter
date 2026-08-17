// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_type.dart';
import 'user_base_response.dart';

part 'post_with_author_response.freezed.dart';
part 'post_with_author_response.g.dart';

@Freezed()
abstract class PostWithAuthorResponse with _$PostWithAuthorResponse {
  const factory PostWithAuthorResponse({
    required String id,
    required String title,
    required String content,

    /// FULL URL
    required String? thumbnail,
    required DateTime createdAt,
    required PostType type,
    required num viewCount,
    required num commentCount,
    required UserBaseResponse author,
  }) = _PostWithAuthorResponse;

  factory PostWithAuthorResponse.fromJson(Map<String, Object?> json) => _$PostWithAuthorResponseFromJson(json);
}
