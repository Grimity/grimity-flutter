import 'package:freezed_annotation/freezed_annotation.dart';

part 'presigned_url.freezed.dart';
part 'presigned_url.g.dart';

@freezed
abstract class PresignedUrl with _$PresignedUrl {
  const factory PresignedUrl({required String url, required String imageName}) = _PresignedUrl;

  factory PresignedUrl.fromJson(Map<String, Object?> json) => _$PresignedUrlFromJson(json);
}
