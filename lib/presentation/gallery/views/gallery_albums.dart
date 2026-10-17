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

  final ValueNotifier<bool> showAlbums;
  final ValueNotifier<AssetPathEntity?> selectedAlbum;

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GalleryAlbumService.new);

    return service.when(
      loading: () {
        return const Center(
          child: GdsCircularLoading(),
        );
      },
      failed: (error, stackTrace) {
        return GdsErrorState(
          retry: service.refresh,
          error: error,
          stackTrace: stackTrace,
        );
      },
      loaded: (items) {
        if (items.isEmpty) {
          return GdsEmptyState(
            illust: .resultNull,
            title: '선택할 앨범이 없어요.',
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final album = items[index];

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
