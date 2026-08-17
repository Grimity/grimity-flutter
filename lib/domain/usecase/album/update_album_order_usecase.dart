import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/data/service/album_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAlbumOrderUseCase extends UseCase<UpdateAlbumOrderRequestParam, Result<void>> {
  UpdateAlbumOrderUseCase(this._albumService);

  final AlbumService _albumService;

  @override
  FutureOr<Result<void>> execute(UpdateAlbumOrderRequestParam request) async {
    return await _albumService.updateAlbumOrder(request);
  }
}
