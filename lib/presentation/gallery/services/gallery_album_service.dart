import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 기기의 이미지 앨범 목록을 조회하는 서비스.
class GalleryAlbumService extends Service<List<AssetPathEntity>> {
  @override
  Future<List<AssetPathEntity>> fetchData() {
    return PhotoManager.getAssetPathList(type: .image);
  }
}
