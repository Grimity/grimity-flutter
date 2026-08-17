// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_with_count_response.freezed.dart';
part 'album_with_count_response.g.dart';

@Freezed()
abstract class AlbumWithCountResponse with _$AlbumWithCountResponse {
  const factory AlbumWithCountResponse({
    required String id,
    required String name,
    required num feedCount,
  }) = _AlbumWithCountResponse;

  factory AlbumWithCountResponse.fromJson(Map<String, Object?> json) => _$AlbumWithCountResponseFromJson(json);
}
