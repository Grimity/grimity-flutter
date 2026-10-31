// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/gallery/services/gallery_album_service.dart';
import 'package:grimity/presentation/gallery/widgets/gallery_album.dart';
import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 기기의 이미지 앨범 목록을 표시하고 선택하는 위젯.
class GalleryAlbums extends StatelessWidget {
  const new({
    super.key,
    required this.showAlbums,
    required this.selectedAlbum,
  });

  final ValueState<bool> showAlbums;
  final ValueState<AssetPathEntity?> selectedAlbum;

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GalleryAlbumService.new);

    return service.page(
      loaded: (data) {
        if (data.isEmpty) {
          return GdsEmptyState(
            illust: .resultNull,
            title: '선택할 앨범이 없어요.',
          );
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final album = data[index];

            return GalleryAlbum(
              entity: album,
              onTap: () {
                // 전체 앨범은 최근 항목으로 선택하고 목록 닫기.
                selectedAlbum.value = album.isAll ? null : album;
                showAlbums.value = false;
              },
            );
          },
        );
      },
    );
  }
}
