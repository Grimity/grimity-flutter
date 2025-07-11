import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_request_params.freezed.dart';

part 'album_request_params.g.dart';

@freezed
abstract class CreateAlbumRequestParam with _$CreateAlbumRequestParam {
  const factory CreateAlbumRequestParam({required String name}) = _CreateAlbumRequestParam;

  factory CreateAlbumRequestParam.fromJson(Map<String, dynamic> json) => _$CreateAlbumRequestParamFromJson(json);
}

@freezed
abstract class UpdateAlbumOrderRequestParam with _$UpdateAlbumOrderRequestParam {
  const factory UpdateAlbumOrderRequestParam({required List<String> ids}) = _UpdateAlbumOrderRequestParam;

  factory UpdateAlbumOrderRequestParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateAlbumOrderRequestParamFromJson(json);
}

@freezed
abstract class RemoveFeedsAlbumRequestParam with _$RemoveFeedsAlbumRequestParam {
  const factory RemoveFeedsAlbumRequestParam({required List<String> ids}) = _RemoveFeedsAlbumRequestParam;

  factory RemoveFeedsAlbumRequestParam.fromJson(Map<String, dynamic> json) =>
      _$RemoveFeedsAlbumRequestParamFromJson(json);
}

@freezed
abstract class InsertFeedRequestParam with _$InsertFeedRequestParam {
  const factory InsertFeedRequestParam({required List<String> ids}) = _InsertFeedRequestParam;

  factory InsertFeedRequestParam.fromJson(Map<String, dynamic> json) => _$InsertFeedRequestParamFromJson(json);
}

@freezed
abstract class InsertFeedWithIdRequestParam with _$InsertFeedWithIdRequestParam {
  const factory InsertFeedWithIdRequestParam({required String id, required InsertFeedRequestParam param}) =
      _InsertFeedWithIdRequestParam;

  factory InsertFeedWithIdRequestParam.fromJson(Map<String, dynamic> json) =>
      _$InsertFeedWithIdRequestParamFromJson(json);
}

@freezed
abstract class UpdateAlbumRequestParam with _$UpdateAlbumRequestParam {
  const factory UpdateAlbumRequestParam({required String name}) = _UpdateAlbumRequestParam;

  factory UpdateAlbumRequestParam.fromJson(Map<String, dynamic> json) => _$UpdateAlbumRequestParamFromJson(json);
}

@freezed
abstract class UpdateAlbumWithIdRequestParam with _$UpdateAlbumWithIdRequestParam {
  const factory UpdateAlbumWithIdRequestParam({required String id, required UpdateAlbumRequestParam param}) =
      _UpdateAlbumWithIdRequestParam;

  factory UpdateAlbumWithIdRequestParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateAlbumWithIdRequestParamFromJson(json);
}
