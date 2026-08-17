import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/gen/models/id_response.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/data/service/album_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateAlbumUseCase extends UseCase<CreateAlbumRequestParam, Result<IdResponse>> {
  CreateAlbumUseCase(this._albumService);

  final AlbumService _albumService;

  @override
  FutureOr<Result<IdResponse>> execute(CreateAlbumRequestParam request) async {
    return await _albumService.createAlbum(request);
  }
}
