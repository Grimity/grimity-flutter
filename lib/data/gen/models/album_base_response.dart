// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_base_response.freezed.dart';
part 'album_base_response.g.dart';

@Freezed()
abstract class AlbumBaseResponse with _$AlbumBaseResponse {
  const factory AlbumBaseResponse({
    required String id,
    required String name,
  }) = _AlbumBaseResponse;

  factory AlbumBaseResponse.fromJson(Map<String, Object?> json) => _$AlbumBaseResponseFromJson(json);
}
