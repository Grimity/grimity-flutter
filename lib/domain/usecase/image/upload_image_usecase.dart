import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/data/service/image_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadImageUseCase extends UseCase<UploadImageRequest, Result<void>> {
  UploadImageUseCase(this._imageService);

  final ImageService _imageService;

  @override
  Future<Result<void>> execute(UploadImageRequest request) async {
    return await _imageService.uploadImage(request);
  }
}

@injectable
class UploadImagesUseCase extends UseCase<List<UploadImageRequest>, Result<void>> {
  UploadImagesUseCase(this._imageService);

  final ImageService _imageService;

  @override
  Future<Result<void>> execute(List<UploadImageRequest> requests) async {
    return await _imageService.uploadImages(requests);
  }
}
