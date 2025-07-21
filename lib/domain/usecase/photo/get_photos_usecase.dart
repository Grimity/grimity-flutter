import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/photo_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

@injectable
class GetPhotoUseCase extends UseCase<int, Result<List<AssetEntity>>> {
  GetPhotoUseCase(this._photoRepository);

  final PhotoRepository _photoRepository;

  @override
  FutureOr<Result<List<AssetEntity>>> execute(int page) async {
    return await _photoRepository.fetchPhotos(page);
  }
}
