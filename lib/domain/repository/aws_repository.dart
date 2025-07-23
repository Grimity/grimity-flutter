import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:grimity/domain/entity/presigned_url.dart';

abstract class AWSRepository {
  Future<Result<PresignedUrl>> getPresignedUrl(GetPresignedUrlRequest request);
  Future<Result<List<PresignedUrl>>> getPresignedUrls(List<GetPresignedUrlRequest> requests);
  Future<Result<void>> uploadImage(UploadImageRequest request);
  Future<Result<void>> uploadImages(List<UploadImageRequest> requests);
}
