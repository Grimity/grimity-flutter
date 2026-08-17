import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyAlbumsUseCase extends NoParamUseCase<Result<List<Album>>> {
  GetMyAlbumsUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<List<Album>>> execute() async {
    return await _meService.getMyAlbums();
  }
}
