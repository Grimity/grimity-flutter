// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'remove_feeds_album_request.freezed.dart';
part 'remove_feeds_album_request.g.dart';

@Freezed()
abstract class RemoveFeedsAlbumRequest with _$RemoveFeedsAlbumRequest {
  const factory RemoveFeedsAlbumRequest({
    required List<String> ids,
  }) = _RemoveFeedsAlbumRequest;

  factory RemoveFeedsAlbumRequest.fromJson(Map<String, Object?> json) => _$RemoveFeedsAlbumRequestFromJson(json);
}
