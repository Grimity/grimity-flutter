import 'package:dio/dio.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/exception/album_name_conflict_exception.dart';
import 'package:grimity/data/data_source/remote/album_api.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/repository/album_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AlbumRepository)
class AlbumRepositoryImpl extends AlbumRepository {
  final AlbumAPI _albumAPI;

  AlbumRepositoryImpl(this._albumAPI);

  @override
  Future<Result<IdResponse>> createAlbum(CreateAlbumRequestParam request) async {
    try {
      final IdResponse response = await _albumAPI.createAlbum(request);
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

  @override
  Future<Result<void>> updateAlbumOrder(UpdateAlbumOrderRequestParam request) async {
    try {
      await _albumAPI.updateAlbumOrder(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> removeFeedsAlbum(RemoveFeedsAlbumRequestParam request) async {
    try {
      await _albumAPI.removeFeedsAlbum(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> insertFeedToAlbum(InsertFeedWithIdRequestParam request) async {
    try {
      await _albumAPI.insertFeedToAlbum(request.id, request.param);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> updateAlbum(UpdateAlbumWithIdRequestParam request) async {
    try {
      await _albumAPI.updateAlbum(request.id, request.param);
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

  @override
  Future<Result<void>> deleteAlbum(String id) async {
    try {
      await _albumAPI.deleteAlbum(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
