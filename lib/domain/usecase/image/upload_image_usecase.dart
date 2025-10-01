import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/repository/image_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadImageUseCase extends UseCase<UploadImageRequest, Result<void>> {
  UploadImageUseCase(this._imageRepository);

  final ImageRepository _imageRepository;

  @override
  Future<Result<void>> execute(UploadImageRequest request) async {
    return await _imageRepository.uploadImage(request);
  }
}

@injectable
class UploadImagesUseCase extends UseCase<List<UploadImageRequest>, Result<void>> {
  UploadImagesUseCase(this._imageRepository);

  final ImageRepository _imageRepository;

  @override
  Future<Result<void>> execute(List<UploadImageRequest> requests) async {
    return await _imageRepository.uploadImages(requests);
  }
}
