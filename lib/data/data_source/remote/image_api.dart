import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/image/image_upload_url_response.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'image_api.g.dart';

@injectable
@RestApi()
abstract class ImageAPI {
  @factoryMethod
  factory ImageAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _ImageAPI;

  @POST('/images/get-upload-url')
  Future<ImageUploadUrlResponse> getUploadUrl(@Body() GetImageUploadUrlRequest request);

  @POST('/images/get-upload-urls')
  Future<List<ImageUploadUrlResponse>> getUploadUrls(@Body() List<GetImageUploadUrlRequest> requests);
}
