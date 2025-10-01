import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/image_api.dart';
import 'package:grimity/data/model/image/image_upload_url_response.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';
import 'package:grimity/domain/repository/image_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ImageRepository)
class ImageRepositoryImpl extends ImageRepository {
  final ImageAPI _imageAPI;

  ImageRepositoryImpl(this._imageAPI);

  @override
  Future<Result<ImageUploadUrl>> getUploadUrl(GetImageUploadUrlRequest request) async {
    try {
      final ImageUploadUrlResponse response = await _imageAPI.getUploadUrl(request);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<List<ImageUploadUrl>>> getUploadUrls(List<GetImageUploadUrlRequest> requests) async {
    try {
      final List<ImageUploadUrlResponse> response = await _imageAPI.getUploadUrls(requests);
      return Result.success(response.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> uploadImage(UploadImageRequest request) async {
    try {
      final bytes = await File(request.filePath).readAsBytes();
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        quality: 90,
        format: CompressFormat.webp,
      );
      await Dio().put(request.url, data: compressedBytes, options: Options(headers: {'Content-Type': 'image/webp'}));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> uploadImages(List<UploadImageRequest> requests) async {
    try {
      await Future.wait(
        requests.map((request) async {
          final bytes = await File(request.filePath).readAsBytes();
          final compressedBytes = await FlutterImageCompress.compressWithList(
            bytes,
            quality: 90,
            format: CompressFormat.webp,
          );
          await Dio().put(
            request.url,
            data: compressedBytes,
            options: Options(headers: {'Content-Type': 'image/webp'}),
          );
        }),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
