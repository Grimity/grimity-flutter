import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_with_count.freezed.dart';
part 'album_with_count.g.dart';

@freezed
abstract class AlbumWithCount with _$AlbumWithCount {
  const factory AlbumWithCount({required String id, required String name, required int feedCount}) = _AlbumWithCount;

  factory AlbumWithCount.fromJson(Map<String, dynamic> json) => _$AlbumWithCountFromJson(json);
}
