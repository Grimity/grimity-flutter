import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/album_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAlbumUseCase extends UseCase<String, Result<void>> {
  DeleteAlbumUseCase(this._albumRepository);

  final AlbumRepository _albumRepository;

  @override
  FutureOr<Result<void>> execute(String request) async {
    return await _albumRepository.deleteAlbum(request);
  }
}
