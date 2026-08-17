import 'package:dio/dio.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/exception/album_name_conflict_exception.dart';
import 'package:grimity/data/gen/models/create_album_request.dart' as generated;
import 'package:grimity/data/gen/models/id_response.dart';
import 'package:grimity/data/gen/models/insert_feeds_request.dart' as generated;
import 'package:grimity/data/gen/models/remove_feeds_album_request.dart' as generated;
import 'package:grimity/data/gen/models/update_album_order_request.dart' as generated;
import 'package:grimity/data/gen/models/update_album_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AlbumService {
  final RestClient _client;

  AlbumService(this._client);

  Future<Result<IdResponse>> createAlbum(CreateAlbumRequestParam request) async {
    try {
      final response = await _client.albums.albumCreate(body: generated.CreateAlbumRequest.fromJson(request.toJson()));
      return Result.success(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Result.failure(AlbumNameConflictException(e));
      }

      return Result.failure(e);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateAlbumOrder(UpdateAlbumOrderRequestParam request) async {
    try {
      await _client.albums.albumUpdateOrder(body: generated.UpdateAlbumOrderRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> removeFeedsAlbum(RemoveFeedsAlbumRequestParam request) async {
    try {
      await _client.albums.albumRemoveFeeds(body: generated.RemoveFeedsAlbumRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> insertFeedToAlbum(InsertFeedWithIdRequestParam request) async {
    try {
      await _client.albums.albumInsertFeeds(
        id: request.id,
        body: generated.InsertFeedsRequest.fromJson(request.param.toJson()),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateAlbum(UpdateAlbumWithIdRequestParam request) async {
    try {
      await _client.albums.albumUpdateOne(
        id: request.id,
        body: generated.UpdateAlbumRequest.fromJson(request.param.toJson()),
      );
      return Result.success(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Result.failure(AlbumNameConflictException(e));
      }

      return Result.failure(e);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteAlbum(String id) async {
    try {
      await _client.albums.albumDeleteOne(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
