import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/repository/album_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAlbumUseCase extends UseCase<UpdateAlbumWithIdRequestParam, Result<void>> {
  UpdateAlbumUseCase(this._albumRepository);

  final AlbumRepository _albumRepository;

  @override
  FutureOr<Result<void>> execute(UpdateAlbumWithIdRequestParam request) async {
    return await _albumRepository.updateAlbum(request);
  }
}
