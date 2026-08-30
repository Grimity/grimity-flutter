import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:grimity/domain/usecase/photo_usecases.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_page_argument_provider.dart';
import 'package:grimity/presentation/photo_select/state/photo_select_state.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_select_provider.g.dart';

@riverpod
class PhotoSelect extends _$PhotoSelect {
  @override
  FutureOr<PhotoSelectState> build(UploadImageType type) async {
    final permission = await PhotoManager.requestPermissionExtend();

    // 접근 권한이 없는 경우
    if (!permission.hasAccess) {
      return PhotoSelectState(hasAccess: permission.hasAccess, isAuth: permission.isAuth);
    }

    final prevSelected = type == UploadImageType.feed ? ref.read(feedUploadProvider).images : <ImageSourceItem>[];
    final prevThumbNail = type == UploadImageType.feed ? ref.read(feedUploadProvider).thumbnailImage : null;

    // 기기 앨범 목록 조회(첫 번째 = 최근 항목)
    final albumsResult = await getAlbumsUseCase.execute();
    final albums = albumsResult.fold(onSuccess: (a) => a, onFailure: (_) => <PhotoAlbum>[]);
    final currentAlbum = albums.isNotEmpty ? albums.first : null;

    // 전체 접근 허용 || 제한된 사진 접근 허용
    final result = await fetchPhotoUseCase.execute((page: 0, album: currentAlbum?.path));
    return result.fold(
      onSuccess: (photos) {
        return PhotoSelectState(
          hasAccess: permission.hasAccess,
          isAuth: permission.isAuth,
          photos: photos,
          selected: prevSelected,
          thumbnailImage: prevThumbNail,
          albums: albums,
          currentAlbum: currentAlbum?.path,
          albumName: currentAlbum?.displayName ?? '최근 항목',
          hasMore: photos.length == 50,
        );
      },
      onFailure: (e) {
        return PhotoSelectState(
          hasAccess: permission.hasAccess,
          isAuth: permission.isAuth,
          selected: prevSelected,
          thumbnailImage: prevThumbNail,
          albums: albums,
          currentAlbum: currentAlbum?.path,
          albumName: currentAlbum?.displayName ?? '최근 항목',
        );
      },
    );
  }

  /// photo LoadMore
  Future<void> loadMore() async {
    final data = state.value;
    if (data == null || !data.hasMore) return;

    final nextPage = data.page + 1;
    final newAssets = await fetchPhotoUseCase.execute((page: nextPage, album: data.currentAlbum));

    newAssets.fold(
      onSuccess: (newPhotos) {
        final hasMore = newPhotos.length == 50;
        final updatedPhotos = [...data.photos, ...newPhotos];

        state = AsyncData(data.copyWith(photos: updatedPhotos, page: nextPage, hasMore: hasMore));
      },
      onFailure: (e) {},
    );
  }

  /// 앨범 목록 펼침/접힘 토글
  void toggleAlbumList() {
    state = state.whenData((data) => data.copyWith(isAlbumListExpanded: !data.isAlbumListExpanded));
  }

  /// 앨범 선택 → 해당 앨범 사진으로 갱신하고 목록을 닫습니다.
  Future<void> selectAlbum(PhotoAlbum album) async {
    final data = state.value;
    if (data == null) return;

    // 목록을 먼저 닫습니다. 앨범명/사진은 조회 성공 시 함께 반영해 상태 불일치를 방지합니다.
    state = AsyncData(data.copyWith(isAlbumListExpanded: false));

    final result = await fetchPhotoUseCase.execute((page: 0, album: album.path));
    result.fold(
      onSuccess: (photos) {
        final current = state.value ?? data;
        state = AsyncData(
          current.copyWith(
            currentAlbum: album.path,
            albumName: album.displayName,
            photos: photos,
            page: 0,
            hasMore: photos.length == 50,
          ),
        );
      },
      onFailure: (e) {},
    );
  }

  /// 이미지 선택 토글
  void toggleImageSelection(ImageSourceItem image) {
    state = state.whenData((data) {
      final selected = [...data.selected];
      final isAdd = !selected.contains(image);

      /// 제거
      if (!isAdd) {
        selected.remove(image);
        final newThumbnail = image == data.thumbnailImage
            ? (selected.isNotEmpty ? selected.first : null)
            : data.thumbnailImage;
        return data.copyWith(selected: selected, thumbnailImage: newThumbnail);
      }

      if (selected.length >= 10) {
        ToastService.showFailure('최대 10개까지 추가 가능합니다');
        return data;
      }

      /// 추가
      selected.add(image);
      final newThumbnail = selected.length == 1 ? image : data.thumbnailImage;

      return data.copyWith(selected: selected, thumbnailImage: newThumbnail);
    });
  }

  /// 선택된 이미지 제거
  void removeSelectedImage(ImageSourceItem image) {
    state = state.whenData((data) {
      final selected = [...data.selected];
      selected.remove(image);
      final newThumbnail = image == data.thumbnailImage
          ? (selected.isNotEmpty ? selected.first : null)
          : data.thumbnailImage;
      return data.copyWith(selected: selected, thumbnailImage: newThumbnail);
    });
  }

  /// 이미지 전달
  // ignore: avoid_build_context_in_providers
  void completeImageSelect(BuildContext context) {
    if (state.value == null) return;
    final images = state.value!.selected;

    if (type == UploadImageType.feed) {
      final thumbnailImage = state.value!.thumbnailImage;
      ref.read(feedUploadProvider.notifier).updateImages(images);
      ref.read(feedUploadProvider.notifier).updateThumbnailImage(thumbnailImage ?? images.first);
    } else {
      ref.read(postUploadProvider.notifier).updateImages(images);
    }

    context.pop(images);
  }
}

mixin class PhotoSelectMixin {
  AsyncValue<PhotoSelectState> photosAsync(WidgetRef ref) {
    final type = ref.read(photoSelectTypeArgumentProvider);
    return ref.watch(photoSelectProvider(type));
  }

  PhotoSelect photoNotifier(WidgetRef ref) {
    final type = ref.read(photoSelectTypeArgumentProvider);
    return ref.read(photoSelectProvider(type).notifier);
  }

  void invalidatePhotoSelect(WidgetRef ref) {
    final type = ref.read(photoSelectTypeArgumentProvider);
    ref.invalidate(photoSelectProvider(type));
  }
}
