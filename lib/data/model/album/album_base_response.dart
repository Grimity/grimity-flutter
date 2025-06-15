import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/album.dart';

part 'album_base_response.freezed.dart';
part 'album_base_response.g.dart';

@Freezed(copyWith: false)
abstract class AlbumBaseResponse with _$AlbumBaseResponse {
  const factory AlbumBaseResponse({required String id, required String name}) = _AlbumBaseResponse;

  factory AlbumBaseResponse.fromJson(Map<String, dynamic> json) => _$AlbumBaseResponseFromJson(json);
}

extension AlbumBaseResponseX on AlbumBaseResponse {
  Album toEntity() {
    return Album(id: id, name: name);
  }
}
