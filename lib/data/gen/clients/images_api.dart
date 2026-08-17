// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_image_upload_url_request.dart';
import '../models/image_upload_url_response.dart';

part 'images_api.g.dart';

@RestApi()
abstract class ImagesApi {
  factory ImagesApi(Dio dio, {String? baseUrl}) = _ImagesApi;

  /// 이미지 업로드용 presignedURL 발급
  @POST('/images/get-upload-url')
  Future<ImageUploadUrlResponse> imageGetImageUploadUrl({
    @Body() required GetImageUploadUrlRequest body,
  });

  /// 이미지 업로드용 presignedURL 여러개 발급
  @POST('/images/get-upload-urls')
  Future<List<ImageUploadUrlResponse>> imageGetImageUploadUrls({
    @Body() required List<GetImageUploadUrlRequest> body,
  });
}
