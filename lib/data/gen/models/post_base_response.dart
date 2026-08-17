// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_base_response.freezed.dart';
part 'post_base_response.g.dart';

@Freezed()
abstract class PostBaseResponse with _$PostBaseResponse {
  const factory PostBaseResponse({
    required String id,
    required String title,
    required String content,

    /// FULL URL
    required String? thumbnail,
    required DateTime createdAt,
  }) = _PostBaseResponse;

  factory PostBaseResponse.fromJson(Map<String, Object?> json) => _$PostBaseResponseFromJson(json);
}
