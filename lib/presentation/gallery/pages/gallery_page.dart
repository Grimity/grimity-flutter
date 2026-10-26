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
  const new({super.key});

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
    final canSubmit = selectedImages.value.isNotEmpty;

    void onTitle() {
      showAlbums.value = !showAlbums.value;
    }

    return GdsScaffold(
      appBar: GdsTopNavigation.editor(
        onBack: context.pop,
        onTitle: canSelectAlbum ? onTitle : null,
        action: .new(
          label: '다음',
          onTap: () {
            final providers = selectedImages.value.builder((asset) {
              return asset.toImage();
            });

            // 선택한 이미지 목록을 반환하고 갤러리 닫기.
            context.pop(providers);
          },
          enabled: canSubmit,
        ),
        title: selectedAlbum.value?.name ?? '최근 항목',
        open: showAlbums.value,
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
                key: ValueKey(showAlbums.value),
                builder: (context) {
                  if (showAlbums.value) {
                    return GalleryAlbums(
                      showAlbums: showAlbums,
                      selectedAlbum: selectedAlbum,
                    );
                  }

                  return GalleryImages(
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
