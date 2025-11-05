import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/presigned.enum.dart';

part 'image_request_params.freezed.dart';

part 'image_request_params.g.dart';

@freezed
abstract class GetImageUploadUrlRequest with _$GetImageUploadUrlRequest {
  const factory GetImageUploadUrlRequest({
    required PresignedType type,
    required PresignedExt ext,
    required int width,
    required int height,
  }) = _GetImageUploadUrlRequest;

  factory GetImageUploadUrlRequest.fromJson(Map<String, dynamic> json) => _$GetImageUploadUrlRequestFromJson(json);
}

@freezed
abstract class UploadImageRequest with _$UploadImageRequest {
  const factory UploadImageRequest({required String url, required String filePath}) = _UploadImageRequest;

  factory UploadImageRequest.fromJson(Map<String, dynamic> json) => _$UploadImageRequestFromJson(json);
}
