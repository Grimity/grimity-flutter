import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:grimity/domain/repository/photo_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

@Injectable(as: PhotoRepository)
class PhotoRepositoryImpl implements PhotoRepository {
  @override
  Future<Result<List<AssetEntity>>> fetchPhotos(int page, {AssetPathEntity? album}) async {
    var target = album;

    // 앨범이 지정되지 않은 경우 전체(최근 항목) 앨범을 사용합니다.
    if (target == null) {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);
      if (albums.isEmpty) return Result.success([]);
      target = albums.first;
    }

    final assets = await target.getAssetListPaged(page: page, size: 50);
    return Result.success(assets);
  }

  @override
  Future<Result<List<PhotoAlbum>>> fetchAlbums() async {
    final paths = await PhotoManager.getAssetPathList(type: RequestType.image);

    final albums = <PhotoAlbum>[];
    for (final path in paths) {
      final count = await path.assetCountAsync;
      if (count == 0) continue;

      final first = await path.getAssetListRange(start: 0, end: 1);
      albums.add(PhotoAlbum(path: path, count: count, cover: first.isNotEmpty ? first.first : null));
    }

    return Result.success(albums);
  }
}
