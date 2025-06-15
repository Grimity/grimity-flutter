import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/presigned.enum.dart';

part 'aws_request_params.freezed.dart';
part 'aws_request_params.g.dart';

@freezed
abstract class GetPresignedUrlRequest with _$GetPresignedUrlRequest {
  const factory GetPresignedUrlRequest({required PresignedType type, required PresignedExt ext}) =
      _GetPresignedUrlRequest;

  factory GetPresignedUrlRequest.fromJson(Map<String, dynamic> json) => _$GetPresignedUrlRequestFromJson(json);
}

@freezed
abstract class UploadImageRequest with _$UploadImageRequest {
  const factory UploadImageRequest({required String url, required String filePath}) = _UploadImageRequest;

  factory UploadImageRequest.fromJson(Map<String, dynamic> json) => _$UploadImageRequestFromJson(json);
}
