// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_album_order_request.freezed.dart';
part 'update_album_order_request.g.dart';

@Freezed()
abstract class UpdateAlbumOrderRequest with _$UpdateAlbumOrderRequest {
  const factory UpdateAlbumOrderRequest({
    /// 앨범 ID들만 배열로 담아서 주시면됩니다
    required List<String> ids,
  }) = _UpdateAlbumOrderRequest;

  factory UpdateAlbumOrderRequest.fromJson(Map<String, Object?> json) => _$UpdateAlbumOrderRequestFromJson(json);
}
