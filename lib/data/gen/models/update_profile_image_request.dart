// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_image_request.freezed.dart';
part 'update_profile_image_request.g.dart';

@Freezed()
abstract class UpdateProfileImageRequest with _$UpdateProfileImageRequest {
  const factory UpdateProfileImageRequest({
    required String imageName,
  }) = _UpdateProfileImageRequest;

  factory UpdateProfileImageRequest.fromJson(Map<String, Object?> json) => _$UpdateProfileImageRequestFromJson(json);
}
