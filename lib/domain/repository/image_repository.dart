import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';

abstract class ImageRepository {
  Future<Result<ImageUploadUrl>> getUploadUrl(GetImageUploadUrlRequest request);

  Future<Result<List<ImageUploadUrl>>> getUploadUrls(List<GetImageUploadUrlRequest> requests);

  Future<Result<void>> uploadImage(UploadImageRequest request);

  Future<Result<void>> uploadImages(List<UploadImageRequest> requests);
}
