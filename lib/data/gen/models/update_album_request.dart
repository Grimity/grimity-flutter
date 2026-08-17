// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_album_request.freezed.dart';
part 'update_album_request.g.dart';

@Freezed()
abstract class UpdateAlbumRequest with _$UpdateAlbumRequest {
  const factory UpdateAlbumRequest({
    /// 앨범 개수는 최대 8개
    required String name,
  }) = _UpdateAlbumRequest;

  factory UpdateAlbumRequest.fromJson(Map<String, Object?> json) => _$UpdateAlbumRequestFromJson(json);
}
