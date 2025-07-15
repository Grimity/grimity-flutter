import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/aws/presigned_url_response.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'aws_api.g.dart';

@injectable
@RestApi()
abstract class AWSAPI {
  @factoryMethod
  factory AWSAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _AWSAPI;

  @POST('/aws/image-upload-url')
  Future<PresignedUrlResponse> getPresignedUrl(@Body() GetPresignedUrlRequest request);

  @POST('/aws/image-upload-urls')
  Future<List<PresignedUrlResponse>> getPresignedUrls(@Body() List<GetPresignedUrlRequest> requests);
}
