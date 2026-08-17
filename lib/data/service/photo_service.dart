import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

@lazySingleton
class PhotoService {
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

  Future<Result<List<PhotoAlbum>>> fetchAlbums() async {
    final paths = await PhotoManager.getAssetPathList(type: RequestType.image);

    // 앨범별 정보를 병렬로 조회하여 성능을 개선합니다.
    final albumFutures = paths.map((path) async {
      final count = await path.assetCountAsync;
      if (count == 0) return null;

      final first = await path.getAssetListRange(start: 0, end: 1);
      return PhotoAlbum(path: path, count: count, cover: first.isNotEmpty ? first.first : null);
    });

    final results = await Future.wait(albumFutures);
    final albums = results.whereType<PhotoAlbum>().toList();

    return Result.success(albums);
  }
}
