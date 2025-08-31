import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/usecase/photo_usecases.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_page_argument_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_select_provider.g.dart';

part 'photo_select_provider.freezed.dart';

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

    // 전체 접근 허용 || 제한된 사진 접근 허용
    final result = await fetchPhotoUseCase.execute(0);
    return result.fold(
      onSuccess: (photos) {
        return PhotoSelectState(
          hasAccess: permission.hasAccess,
          isAuth: permission.isAuth,
          photos: photos,
          selected: prevSelected,
          thumbnailImage: prevThumbNail,
        );
      },
      onFailure: (e) {
        return PhotoSelectState(
          hasAccess: permission.hasAccess,
          isAuth: permission.isAuth,
          selected: prevSelected,
          thumbnailImage: prevThumbNail,
        );
      },
    );
  }

  /// photo LoadMore
  Future<void> loadMore() async {
    final data = state.value;
    if (data == null || data.isLoadingMore || !data.hasMore) return;

    state = AsyncData(data.copyWith(isLoadingMore: true));

    final nextPage = data.page + 1;
    final newAssets = await fetchPhotoUseCase.execute(nextPage);

    newAssets.fold(
      onSuccess: (newPhotos) {
        final hasMore = newPhotos.length == 50;
        final updatedPhotos = [...data.photos, ...newPhotos];

        state = AsyncData(data.copyWith(photos: updatedPhotos, page: nextPage, isLoadingMore: false, hasMore: hasMore));
      },
      onFailure: (e) {
        state = AsyncData(data.copyWith(isLoadingMore: false));
      },
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
        final newThumbnail =
            image == data.thumbnailImage ? (selected.isNotEmpty ? selected.first : null) : data.thumbnailImage;
        return data.copyWith(selected: selected, thumbnailImage: newThumbnail);
      }

      if (selected.length >= 10) {
        ToastService.showError('최대 10개까지 추가 가능합니다');
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
      final newThumbnail =
          image == data.thumbnailImage ? (selected.isNotEmpty ? selected.first : null) : data.thumbnailImage;
      return data.copyWith(selected: selected, thumbnailImage: newThumbnail);
    });
  }

  /// 이미지 전달
  void completeImageSelect() {
    if (state.value == null) return;

    if (type == UploadImageType.feed) {
      final images = state.value!.selected;
      final thumbnailImage = state.value!.thumbnailImage;
      ref.read(feedUploadProvider.notifier).updateImages(images);
      ref.read(feedUploadProvider.notifier).updateThumbnailImage(thumbnailImage ?? images.first);
    } else {
      /// TODO Post
    }
  }
}

@freezed
abstract class PhotoSelectState with _$PhotoSelectState {
  const factory PhotoSelectState({
    @Default(false) bool hasAccess, // 전체 접근 권한 || 선택 접근 권한
    @Default(false) bool isAuth, // 전체 접근 권한
    @Default([]) List<AssetEntity> photos, // 갤러리 이미지
    @Default([]) List<ImageSourceItem> selected, // 선택된 이미지
    ImageSourceItem? thumbnailImage, // 썸네일 이미지
    @Default(0) int page,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
  }) = _PhotoSelectState;
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
}
