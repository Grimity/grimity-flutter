// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 기기의 이미지 앨범 목록을 조회하는 서비스.
class GalleryAlbumService extends Service<List<AssetPathEntity>> {
  @override
  Future<List<AssetPathEntity>> fetchData() {
    return PhotoManager.getAssetPathList(type: .image);
  }
}
