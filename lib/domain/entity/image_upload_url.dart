import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_upload_url.freezed.dart';

part 'image_upload_url.g.dart';

@freezed
abstract class ImageUploadUrl with _$ImageUploadUrl {
  const factory ImageUploadUrl({required String uploadUrl, required String imageName, required String imageUrl}) =
      _ImageUploadUrl;

  factory ImageUploadUrl.fromJson(Map<String, Object?> json) => _$ImageUploadUrlFromJson(json);
}
