import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/repository/album_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAlbumOrderUseCase extends UseCase<UpdateAlbumOrderRequestParam, Result<void>> {
  UpdateAlbumOrderUseCase(this._albumRepository);

  final AlbumRepository _albumRepository;

  @override
  FutureOr<Result<void>> execute(UpdateAlbumOrderRequestParam request) async {
    return await _albumRepository.updateAlbumOrder(request);
  }
}
