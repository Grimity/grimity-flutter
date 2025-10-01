import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';
import 'package:grimity/domain/repository/image_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetImageUploadUrlUseCase extends UseCase<GetImageUploadUrlRequest, Result<ImageUploadUrl>> {
  GetImageUploadUrlUseCase(this._imageRepository);

  final ImageRepository _imageRepository;

  @override
  Future<Result<ImageUploadUrl>> execute(GetImageUploadUrlRequest request) async {
    return await _imageRepository.getUploadUrl(request);
  }
}

@injectable
class GetImageUploadUrlsUseCase extends UseCase<List<GetImageUploadUrlRequest>, Result<List<ImageUploadUrl>>> {
  GetImageUploadUrlsUseCase(this._imageRepository);

  final ImageRepository _imageRepository;

  @override
  Future<Result<List<ImageUploadUrl>>> execute(List<GetImageUploadUrlRequest> requests) async {
    return await _imageRepository.getUploadUrls(requests);
  }
}
