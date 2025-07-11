import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/repository/album_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveFeedsAlbumUseCase extends UseCase<RemoveFeedsAlbumRequestParam, Result<void>> {
  RemoveFeedsAlbumUseCase(this._albumRepository);

  final AlbumRepository _albumRepository;

  @override
  FutureOr<Result<void>> execute(RemoveFeedsAlbumRequestParam request) async {
    return await _albumRepository.removeFeedsAlbum(request);
  }
}
