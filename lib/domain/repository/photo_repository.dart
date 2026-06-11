import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class PhotoRepository {
  /// [album]이 주어지면 해당 앨범, 없으면 전체(최근 항목) 앨범의 사진을 페이지 단위로 가져옵니다.
  Future<Result<List<AssetEntity>>> fetchPhotos(int page, {AssetPathEntity? album});

  /// 기기의 사진 앨범 목록을 가져옵니다.
  Future<Result<List<PhotoAlbum>>> fetchAlbums();
}
