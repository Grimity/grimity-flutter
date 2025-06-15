import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/presigned_url.dart';

part 'presigned_url_response.freezed.dart';
part 'presigned_url_response.g.dart';

@freezed
abstract class PresignedUrlResponse with _$PresignedUrlResponse {
  const factory PresignedUrlResponse({required String url, required String imageName}) = _PresignedUrlResponse;

  factory PresignedUrlResponse.fromJson(Map<String, Object?> json) => _$PresignedUrlResponseFromJson(json);
}

extension PresignedUrlResponseX on PresignedUrlResponse {
  PresignedUrl toEntity() {
    return PresignedUrl(url: url, imageName: imageName);
  }
}
