import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/domain/dto/album_request_params.dart';

abstract class AlbumRepository {
  Future<Result<IdResponse>> createAlbum(CreateAlbumRequestParam request);

  Future<Result<void>> updateAlbumOrder(UpdateAlbumOrderRequestParam request);

  Future<Result<void>> removeFeedsAlbum(RemoveFeedsAlbumRequestParam request);

  Future<Result<void>> insertFeedToAlbum(InsertFeedWithIdRequestParam request);

  Future<Result<void>> updateAlbum(UpdateAlbumWithIdRequestParam request);

  Future<Result<void>> deleteAlbum(String id);
}
