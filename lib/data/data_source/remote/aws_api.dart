import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/aws/presigned_url_response.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'aws_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class AWSAPI {
  @factoryMethod
  factory AWSAPI(Dio dio) = _AWSAPI;

  @POST('/aws/image-upload-url')
  Future<PresignedUrlResponse> getPresignedUrl(@Body() GetPresignedUrlRequest request);

  @POST('/aws/image-upload-urls')
  Future<List<PresignedUrlResponse>> getPresignedUrls(@Body() List<GetPresignedUrlRequest> requests);
}
