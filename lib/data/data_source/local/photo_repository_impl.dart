import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/repository/photo_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

@Injectable(as: PhotoRepository)
class PhotoRepositoryImpl implements PhotoRepository {
  @override
  Future<Result<List<AssetEntity>>> fetchPhotos(int page) async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);

    if (albums.isEmpty) return Result.success([]);

    final assets = await albums.first.getAssetListPaged(page: page, size: 50);
    return Result.success(assets);
  }
}
