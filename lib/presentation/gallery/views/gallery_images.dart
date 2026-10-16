import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_photo.dart';
import 'package:grimity/presentation/gallery/services/gallery_image_service.dart';
import 'package:grimity/presentation/gallery/widgets/gallery_image.dart';
import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 선택한 앨범의 이미지를 조회하고 선택하는 갤러리 위젯.
class GalleryImages extends StatelessWidget {
  const new({
    super.key,
    required this.selectedAlbum,
    required this.selectedImages,
  });

  final ValueNotifier<AssetPathEntity?> selectedAlbum;
  final ValueNotifier<List<AssetEntity>> selectedImages;

  /// 선택한 앨범의 이미지를 페이지 단위로 조회하는 서비스를 생성합니다.
  static LoadMoreService<GalleryResponse> createService(AssetPathEntity? album) {
    return LoadMoreService<GalleryResponse>(
      builder: (cursor) => GalleryImageService(
        album: album,
        size: 30,
        page: int.parse(cursor ?? '0'),
      ),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final albumId = selectedAlbum.value?.id;
    final service = context.serviceOf(
      () => createService(selectedAlbum.value),
      key: ValueKey((GalleryImages, albumId)),
    );

    return GdsInfiniteScroll(
      enabled: service.canLoreMore,
      onLoadMore: service.loadMore,
      child: service.when(
        loading: () {
          return Center(
            child: GdsCircularLoading(),
          );
        },
        failed: (error) {
          // 사용자가 권한 요청을 거부했을 경우.
          if (error is PhotoPermissionException) {
            return GdsEmptyState(
              illust: .warning,
              title: '그림 첨부를 위해 접근 권한이 필요해요',
              description: '[설정 - 그리미티 - 사진]에서 “접근"을 허용해 주세요.',
              action: .new(
                label: '사진 접근 허용하기',
                onTap: AppPhoto.requestPermission,
              ),
            );
          }

          // 그 외, 알 수 없는 예외일 경우.
          return GdsEmptyState(
            illust: .warning,
            title: '알 수 없는 에러가 발생했어요',
          );
        },
        loaded: (data) {
          final images = data.expand((page) => page.images).toList();

          // 해당 앨범의 이미지가 아예 없는 경우.
          if (images.isEmpty) {
            return GdsEmptyState(
              illust: .resultNull,
              title: '업로드할 그림이 없어요.',
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.whenDevice(
                mobile: 3,
                tablet: 5,
              ),
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),

            // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
            scrollCacheExtent: .pixels(0),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final asset = images[index];
              final selectedIndex = selectedImages.value.indexOf(asset);

              return GalleryImage(
                asset: asset,
                selectedIndex: selectedIndex,
                onAdd: () => selectedImages.add(asset),
                onRemove: () => selectedImages.remove(asset),
              );
            },
          );
        },
      ),
    );
  }
}
