import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';
import 'package:grimity/data/service/image_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetImageUploadUrlUseCase extends UseCase<GetImageUploadUrlRequest, Result<ImageUploadUrl>> {
  GetImageUploadUrlUseCase(this._imageService);

  final ImageService _imageService;

  @override
  Future<Result<ImageUploadUrl>> execute(GetImageUploadUrlRequest request) async {
    return await _imageService.getUploadUrl(request);
  }
}

@injectable
class GetImageUploadUrlsUseCase extends UseCase<List<GetImageUploadUrlRequest>, Result<List<ImageUploadUrl>>> {
  GetImageUploadUrlsUseCase(this._imageService);

  final ImageService _imageService;

  @override
  Future<Result<List<ImageUploadUrl>>> execute(List<GetImageUploadUrlRequest> requests) async {
    return await _imageService.getUploadUrls(requests);
  }
}
