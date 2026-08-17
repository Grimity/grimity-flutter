// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_type.dart';

part 'create_post_request.freezed.dart';
part 'create_post_request.g.dart';

@Freezed()
abstract class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String title,
    required String content,
    required PostType type,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, Object?> json) => _$CreatePostRequestFromJson(json);
}
