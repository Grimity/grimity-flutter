// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_feed_request.freezed.dart';
part 'update_feed_request.g.dart';

@Freezed()
abstract class UpdateFeedRequest with _$UpdateFeedRequest {
  const factory UpdateFeedRequest({
    required String title,
    required List<String> cards,
    required String content,

    /// 없으면 빈 배열
    required List<String> tags,

    /// 썸네일로 사용할 이미지명
    required String thumbnail,
    String? albumId,
  }) = _UpdateFeedRequest;

  factory UpdateFeedRequest.fromJson(Map<String, Object?> json) => _$UpdateFeedRequestFromJson(json);
}
