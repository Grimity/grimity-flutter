import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';

part 'image_upload_url_response.freezed.dart';

part 'image_upload_url_response.g.dart';

@freezed
abstract class ImageUploadUrlResponse with _$ImageUploadUrlResponse {
  const factory ImageUploadUrlResponse({
    required String uploadUrl,
    required String imageName,
    required String imageUrl,
  }) = _ImageUploadUrlResponse;

  factory ImageUploadUrlResponse.fromJson(Map<String, Object?> json) => _$ImageUploadUrlResponseFromJson(json);
}

extension ImageUploadUrlResponseX on ImageUploadUrlResponse {
  ImageUploadUrl toEntity() {
    return ImageUploadUrl(uploadUrl: uploadUrl, imageName: imageName, imageUrl: imageUrl);
  }
}
