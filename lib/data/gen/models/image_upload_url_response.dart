// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_upload_url_response.freezed.dart';
part 'image_upload_url_response.g.dart';

@Freezed()
abstract class ImageUploadUrlResponse with _$ImageUploadUrlResponse {
  const factory ImageUploadUrlResponse({
    /// presignedURL입니다. 여기로 put 메소드 쏘면 됨
    required String uploadUrl,

    /// 업로드할 이미지의 이름입니다.
    required String imageName,

    /// 업로드 성공했으면 접근가능한 full URL 입니다
    required String imageUrl,
  }) = _ImageUploadUrlResponse;

  factory ImageUploadUrlResponse.fromJson(Map<String, Object?> json) => _$ImageUploadUrlResponseFromJson(json);
}
