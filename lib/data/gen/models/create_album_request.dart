// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_album_request.freezed.dart';
part 'create_album_request.g.dart';

@Freezed()
abstract class CreateAlbumRequest with _$CreateAlbumRequest {
  const factory CreateAlbumRequest({
    /// 앨범 개수는 최대 8개
    required String name,
  }) = _CreateAlbumRequest;

  factory CreateAlbumRequest.fromJson(Map<String, Object?> json) => _$CreateAlbumRequestFromJson(json);
}
