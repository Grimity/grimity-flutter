// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/app/app_photo.dart';
import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 갤러리에서 한 페이지와 다음 페이지의 커서.
typedef GalleryResponse = ({List<AssetEntity> images, String? nextCursor});

/// 접근 권한을 확인하고 앨범 이미지를 페이지 단위로 조회하는 서비스.
class GalleryImageService extends Service<GalleryResponse> {
  new({
    required this.album,
    required this.size,
    required this.page,
  });

  final AssetPathEntity? album;
  final int size;
  final int page;

  @override
  Future<GalleryResponse> fetchData() async {
    if (page == 0) {
      final hasAccess = await AppPhoto.requestPermission();

      // 사용자가 권한 요청을 거부했을 경우.
      if (!hasAccess) {
        throw const PhotoPermissionException();
      }
    }

    // 앨범이 없으면 전체 이미지를 최신순으로 조회.
    final images = album == null
        ? await PhotoManager.getAssetListPaged(
            page: page,
            type: .image,
            pageCount: size,
            filterOption: FilterOptionGroup(
              orders: [const .new(type: .createDate)],
            ),
          )
        : await album!.getAssetListPaged(
            page: page,
            size: size,
            type: .image,
          );

    // 조회 개수가 요청 크기와 같으면 다음 페이지가 있을 것으로 판단.
    final hasNextPage = images.length == size;

    return (
      images: images,
      nextCursor: hasNextPage ? '${page + 1}' : null,
    );
  }
}
