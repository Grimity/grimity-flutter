// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_with_author_response.dart';

part 'my_save_posts_response.freezed.dart';
part 'my_save_posts_response.g.dart';

@Freezed()
abstract class MySavePostsResponse with _$MySavePostsResponse {
  const factory MySavePostsResponse({
    required num totalCount,
    required List<PostWithAuthorResponse> posts,
  }) = _MySavePostsResponse;

  factory MySavePostsResponse.fromJson(Map<String, Object?> json) => _$MySavePostsResponseFromJson(json);
}
