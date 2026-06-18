import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:grimity/domain/repository/photo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAlbumsUseCase extends NoParamUseCase<Result<List<PhotoAlbum>>> {
  GetAlbumsUseCase(this._photoRepository);

  final PhotoRepository _photoRepository;

  @override
  FutureOr<Result<List<PhotoAlbum>>> execute() async {
    return await _photoRepository.fetchAlbums();
  }
}
