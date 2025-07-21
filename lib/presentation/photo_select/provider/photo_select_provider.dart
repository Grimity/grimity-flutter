import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/usecase/photo_usecases.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_select_provider.g.dart';

part 'photo_select_provider.freezed.dart';

@riverpod
class PhotoSelect extends _$PhotoSelect {
  @override
  FutureOr<PhotoSelectState> build() async {
    final permission = await PhotoManager.requestPermissionExtend();

    // 접근 권한이 없는 경우
    if (!permission.hasAccess) {
      return PhotoSelectState(hasAccess: permission.hasAccess, isAuth: permission.isAuth);
    }

    // 전체 접근 허용 || 제한된 사진 접근 허용
    final result = await fetchPhotoUseCase.execute(0);
    return result.fold(
      onSuccess: (photos) {
        return PhotoSelectState(hasAccess: permission.hasAccess, isAuth: permission.isAuth, photos: photos);
      },
      onFailure: (e) {
        return PhotoSelectState(hasAccess: permission.hasAccess, isAuth: permission.isAuth);
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
  void toggleImageSelection(AssetEntity asset) {
    state = state.whenData((data) {
      final selected = [...data.selected];

      if (selected.contains(asset)) {
        selected.remove(asset);
      } else {
        if (selected.length >= 10) {
          ToastService.showError('최대 10개까지 추가 가능합니다');
          return data;
        }
        selected.add(asset);
      }

      return data.copyWith(selected: selected);
    });
  }

  /// 선택된 이미지 제거
  void removeSelectedImage(AssetEntity asset) {
    state = state.whenData((data) {
      final selected = [...data.selected];
      selected.remove(asset);
      return data.copyWith(selected: selected);
    });
  }

  /// 이미지 전달
  void completeImageSelect(List<AssetEntity> images) {
    // ref.read(feedUploadProvider.notifier).updateImages(images);
  }
}

@freezed
abstract class PhotoSelectState with _$PhotoSelectState {
  const factory PhotoSelectState({
    @Default(false) bool hasAccess, // 전체 접근 권한 || 선택 접근 권한
    @Default(false) bool isAuth, // 전체 접근 권한
    @Default([]) List<AssetEntity> photos,
    @Default([]) List<AssetEntity> selected,
    @Default(0) int page,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
  }) = _PhotoSelectState;
}
