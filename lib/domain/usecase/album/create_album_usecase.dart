import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/model/album/album_id_response.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/repository/album_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateAlbumUseCase extends UseCase<CreateAlbumRequestParam, Result<AlbumIdResponse>> {
  CreateAlbumUseCase(this._albumRepository);

  final AlbumRepository _albumRepository;

  @override
  FutureOr<Result<AlbumIdResponse>> execute(CreateAlbumRequestParam request) async {
    return await _albumRepository.createAlbum(request);
  }
}
