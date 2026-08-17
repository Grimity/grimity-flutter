// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'image_ext.dart';
import 'image_type.dart';

part 'get_image_upload_url_request.freezed.dart';
part 'get_image_upload_url_request.g.dart';

@Freezed()
abstract class GetImageUploadUrlRequest with _$GetImageUploadUrlRequest {
  const factory GetImageUploadUrlRequest({
    /// 대소문자 구분 없습니다
    required ImageType type,
    required ImageExt ext,
    required num width,
    required num height,

    /// 원본 파일명. 전달 시 키에 원본 이름이 포함됩니다(확장자 제외). 미전달 시 UUID만 사용.
    String? fileName,
  }) = _GetImageUploadUrlRequest;

  factory GetImageUploadUrlRequest.fromJson(Map<String, Object?> json) => _$GetImageUploadUrlRequestFromJson(json);
}
