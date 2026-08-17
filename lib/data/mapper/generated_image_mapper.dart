import 'package:grimity/data/gen/models/image_upload_url_response.dart' as generated;
import 'package:grimity/domain/entity/image_upload_url.dart';

extension GeneratedImageUploadUrlResponseMapper on generated.ImageUploadUrlResponse {
  ImageUploadUrl toEntity() => ImageUploadUrl(imageName: imageName, imageUrl: imageUrl, uploadUrl: uploadUrl);
}
