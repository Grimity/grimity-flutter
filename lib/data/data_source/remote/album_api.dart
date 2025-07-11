import 'package:dio/dio.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/album/album_id_response.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'album_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class AlbumAPI {
  @factoryMethod
  factory AlbumAPI(Dio dio) = _AlbumAPI;

  @POST('/albums')
  Future<AlbumIdResponse> createAlbum(@Body() CreateAlbumRequestParam request);

  @PUT('/albums/order')
  Future<void> updateAlbumOrder(@Body() UpdateAlbumOrderRequestParam request);

  @PUT('/albums/null')
  Future<void> removeFeedsAlbum(@Body() RemoveFeedsAlbumRequestParam request);

  @PUT('/albums/{id}')
  Future<void> insertFeedToAlbum(@Path('id') String id, @Body() InsertFeedRequestParam request);

  @PATCH('/albums/{id}')
  Future<void> updateAlbum(@Path('id') String id, @Body() UpdateAlbumRequestParam request);

  @DELETE('/albums/{id}')
  Future<void> deleteAlbum(@Path('id') String id);
}
