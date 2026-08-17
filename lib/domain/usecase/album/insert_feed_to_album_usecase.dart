import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/data/service/album_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class InsertFeedToAlbumUseCase extends UseCase<InsertFeedWithIdRequestParam, Result<void>> {
  InsertFeedToAlbumUseCase(this._albumService);

  final AlbumService _albumService;

  @override
  FutureOr<Result<void>> execute(InsertFeedWithIdRequestParam request) async {
    return await _albumService.insertFeedToAlbum(request);
  }
}
