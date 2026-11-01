// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_photo.dart';
import 'package:grimity/extensions/asset_entity_extension.dart';
import 'package:grimity/presentation/gallery/views/gallery_albums.dart';
import 'package:grimity/presentation/gallery/views/gallery_images.dart';
import 'package:grimity/presentation/gallery/widgets/gallery_permission_banner.dart';
import 'package:grimity/presentation/gallery/widgets/gallery_selection_bar.dart';
import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 기기의 앨범과 이미지를 탐색하고 선택한 이미지 목록을 반환하는 페이지.
class GalleryPage extends StatelessWidget {
  const new({
    super.key,
    this.maxCount = 10,
  }) : assert(maxCount > 0);

  /// 선택할 수 있는 이미지의 최대 개수.
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final selectedAlbum = context.stateOf(
      () => null as AssetPathEntity?,
      key: ValueKey('gallery-selected-album'),
    );

    final selectedImages = context.stateOf(
      () => <AssetEntity>[],
      key: ValueKey('gallery-selected-images'),
    );

    // 사진 접근 권한 여부가 업데이트될 때마다 재빌드.
    context.watch(AppPhoto.permissionNotifier);

    // 전체 사진 접근 권한이 있는지 여부.
    final canSelectAlbum = AppPhoto.permission.isAuth;

    // 앨범 목록 화면을 보여줄지 여부.
    final showAlbums = context.stateOf(() => false);

    // 선택한 이미지가 한장이라도 있는지 여부.
    final canSubmit = selectedImages().isNotEmpty;

    void onTitle() {
      showAlbums.set(!showAlbums());
    }

    return GdsScaffold(
      appBar: GdsTopNavigation.editor(
        onBack: context.pop,
        onTitle: canSelectAlbum ? onTitle : null,
        action: .new(
          label: '다음',
          onTap: () {
            final providers = selectedImages().builder((asset) {
              return asset.toImage();
            });

            // 선택한 이미지 목록을 반환하고 갤러리 닫기.
            context.pop(providers);
          },
          enabled: canSubmit,
        ),
        title: selectedAlbum()?.name ?? '최근 항목',
        open: showAlbums(),
      ),
      body: Column(
        children: [
          // 선택된 이미지 목록 표시
          GdsFoldable.builder(
            alignment: .topCenter,
            visible: canSubmit,
            axis: .vertical,
            builder: (context) {
              return GallerySelectionBar(
                selectedImages: selectedImages,
              );
            },
          ),

          // 권한 없으면 권한 안내 배너 표시
          if (!canSelectAlbum) ...[
            GalleryPermissionBanner(),
          ],

          // 이미지 혹은 앨범 선택 뷰어 표시
          Expanded(
            child: GdsPageTransition(
              child: Builder(
                key: ValueKey(showAlbums()),
                builder: (context) {
                  if (showAlbums()) {
                    return GalleryAlbums(
                      showAlbums: showAlbums,
                      selectedAlbum: selectedAlbum,
                    );
                  }

                  return GalleryImages(
                    maxCount: maxCount,
                    selectedAlbum: selectedAlbum,
                    selectedImages: selectedImages,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
