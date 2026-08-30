import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/get_image_upload_url_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_image_mapper.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImageService {
  final RestClient _client;

  ImageService(this._client);

  Future<Result<ImageUploadUrl>> getUploadUrl(GetImageUploadUrlRequest request) async {
    try {
      final response = await _client.images.imageGetImageUploadUrl(
        body: generated.GetImageUploadUrlRequest.fromJson(request.toJson()),
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<ImageUploadUrl>>> getUploadUrls(List<GetImageUploadUrlRequest> requests) async {
    try {
      final response = await _client.images.imageGetImageUploadUrls(
        body: requests.map((request) => generated.GetImageUploadUrlRequest.fromJson(request.toJson())).toList(),
      );
      return Result.success(response.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> uploadImage(UploadImageRequest request) async {
    try {
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
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

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
