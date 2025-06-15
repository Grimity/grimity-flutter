import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/album/album_base_response.dart';
import 'package:grimity/domain/entity/album.dart';

part 'album_with_count_response.freezed.dart';
part 'album_with_count_response.g.dart';

@Freezed(copyWith: false)
abstract class AlbumWithCountResponse with _$AlbumWithCountResponse implements AlbumBaseResponse {
  const AlbumWithCountResponse._();

  const factory AlbumWithCountResponse({required String id, required String name, required int feedCount}) =
      _AlbumWithCountResponse;

  factory AlbumWithCountResponse.fromJson(Map<String, dynamic> json) => _$AlbumWithCountResponseFromJson(json);
}

extension AlbumWithCountResponseX on AlbumWithCountResponse {
  Album toEntity() {
    return Album(id: id, name: name, feedCount: feedCount);
  }
}
