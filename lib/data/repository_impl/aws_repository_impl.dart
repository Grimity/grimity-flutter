import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/aws_api.dart';
import 'package:grimity/data/model/aws/presigned_url_response.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:grimity/domain/entity/presigned_url.dart';
import 'package:grimity/domain/repository/aws_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AWSRepository)
class AWSRepositoryImpl extends AWSRepository {
  final AWSAPI _awsAPI;

  AWSRepositoryImpl(this._awsAPI);

  @override
  Future<Result<PresignedUrl>> getPresignedUrl(GetPresignedUrlRequest request) async {
    try {
      final PresignedUrlResponse response = await _awsAPI.getPresignedUrl(request);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<List<PresignedUrl>>> getPresignedUrls(List<GetPresignedUrlRequest> requests) async {
    try {
      final List<PresignedUrlResponse> response = await _awsAPI.getPresignedUrls(requests);
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
}
