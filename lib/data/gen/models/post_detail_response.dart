// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_type.dart';
import 'user_base_response.dart';

part 'post_detail_response.freezed.dart';
part 'post_detail_response.g.dart';

@Freezed()
abstract class PostDetailResponse with _$PostDetailResponse {
  const factory PostDetailResponse({
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
    required num likeCount,
    required bool isLike,
    required bool isSave,
  }) = _PostDetailResponse;

  factory PostDetailResponse.fromJson(Map<String, Object?> json) => _$PostDetailResponseFromJson(json);
}
