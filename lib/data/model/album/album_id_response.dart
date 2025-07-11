import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_id_response.freezed.dart';

part 'album_id_response.g.dart';

@Freezed(copyWith: false)
abstract class AlbumIdResponse with _$AlbumIdResponse {
  const AlbumIdResponse._();

  const factory AlbumIdResponse({required String id}) = _AlbumIdResponse;

  factory AlbumIdResponse.fromJson(Map<String, dynamic> json) => _$AlbumIdResponseFromJson(json);
}
