// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_album_request.dart';
import '../models/id_response.dart';
import '../models/insert_feeds_request.dart';
import '../models/remove_feeds_album_request.dart';
import '../models/update_album_order_request.dart';
import '../models/update_album_request.dart';

part 'albums_api.g.dart';

@RestApi()
abstract class AlbumsApi {
  factory AlbumsApi(Dio dio, {String? baseUrl}) = _AlbumsApi;

  /// 앨범 생성
  @POST('/albums')
  Future<IdResponse> albumCreate({
    @Body() required CreateAlbumRequest body,
  });

  /// 앨범 순서 변경
  @PUT('/albums/order')
  Future<void> albumUpdateOrder({
    @Body() required UpdateAlbumOrderRequest body,
  });

  /// 앨범에서 피드 빼기
  @PUT('/albums/null')
  Future<void> albumRemoveFeeds({
    @Body() required RemoveFeedsAlbumRequest body,
  });

  /// 앨범에 피드 넣기
  @PUT('/albums/{id}')
  Future<void> albumInsertFeeds({
    @Path('id') required String id,
    @Body() required InsertFeedsRequest body,
  });

  /// 앨범 수정
  @PATCH('/albums/{id}')
  Future<void> albumUpdateOne({
    @Path('id') required String id,
    @Body() required UpdateAlbumRequest body,
  });

  /// 앨범 삭제
  @DELETE('/albums/{id}')
  Future<void> albumDeleteOne({
    @Path('id') required String id,
  });
}
