import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/album.dart';

part 'album_response.freezed.dart';
part 'album_response.g.dart';

@freezed
abstract class AlbumResponse with _$AlbumResponse {
  const factory AlbumResponse({required String id, required String name}) = _AlbumResponse;

  factory AlbumResponse.fromJson(Map<String, dynamic> json) => _$AlbumResponseFromJson(json);
}

extension AlbumResponseX on AlbumResponse {
  Album toEntity() {
    return Album(id: id, name: name);
  }
}
