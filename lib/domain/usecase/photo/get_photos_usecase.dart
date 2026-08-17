import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/photo_service.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

/// 사진 조회 파라미터(페이지 + 대상 앨범)
typedef FetchPhotosParam = ({int page, AssetPathEntity? album});

@injectable
class GetPhotoUseCase extends UseCase<FetchPhotosParam, Result<List<AssetEntity>>> {
  GetPhotoUseCase(this._photoService);

  final PhotoService _photoService;

  @override
  FutureOr<Result<List<AssetEntity>>> execute(FetchPhotosParam request) async {
    return await _photoService.fetchPhotos(request.page, album: request.album);
  }
}
