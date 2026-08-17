import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:grimity/data/service/photo_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAlbumsUseCase extends NoParamUseCase<Result<List<PhotoAlbum>>> {
  GetAlbumsUseCase(this._photoService);

  final PhotoService _photoService;

  @override
  FutureOr<Result<List<PhotoAlbum>>> execute() async {
    return await _photoService.fetchAlbums();
  }
}
