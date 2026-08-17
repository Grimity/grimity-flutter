// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_with_author_response.dart';

part 'posts_response.freezed.dart';
part 'posts_response.g.dart';

@Freezed()
abstract class PostsResponse with _$PostsResponse {
  const factory PostsResponse({
    required num totalCount,
    required List<PostWithAuthorResponse> posts,
  }) = _PostsResponse;

  factory PostsResponse.fromJson(Map<String, Object?> json) => _$PostsResponseFromJson(json);
}
