import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/album_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAlbumUseCase extends UseCase<String, Result<void>> {
  DeleteAlbumUseCase(this._albumService);

  final AlbumService _albumService;

  @override
  FutureOr<Result<void>> execute(String request) async {
    return await _albumService.deleteAlbum(request);
  }
}
