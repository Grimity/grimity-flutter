// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_background_image_request.freezed.dart';
part 'update_background_image_request.g.dart';

@Freezed()
abstract class UpdateBackgroundImageRequest with _$UpdateBackgroundImageRequest {
  const factory UpdateBackgroundImageRequest({
    required String imageName,
  }) = _UpdateBackgroundImageRequest;

  factory UpdateBackgroundImageRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateBackgroundImageRequestFromJson(json);
}
