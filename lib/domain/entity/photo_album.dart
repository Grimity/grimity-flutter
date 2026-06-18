import 'package:photo_manager/photo_manager.dart';

/// 갤러리 앨범 단위 정보(앨범 경로 + 사진 수 + 대표 썸네일)
class PhotoAlbum {
  const PhotoAlbum({required this.path, required this.count, this.cover});

  /// photo_manager 앨범 경로 엔티티
  final AssetPathEntity path;

  /// 앨범에 포함된 사진 수
  final int count;

  /// 앨범 대표 썸네일(가장 최근 사진). 비어 있으면 null
  final AssetEntity? cover;

  String get id => path.id;

  /// 전체(최근 항목) 앨범은 '최근 항목'으로, 그 외에는 앨범명을 그대로 노출
  String get displayName => path.isAll ? '최근 항목' : path.name;

  @override
  bool operator ==(Object other) => other is PhotoAlbum && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
