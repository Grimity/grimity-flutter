import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/album_usecases.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/album_organize/provider/album_feed_data_provider.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_page_argument_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_album_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_organize_provider.g.dart';

part 'album_organize_provider.freezed.dart';

@riverpod
class AlbumOrganize extends _$AlbumOrganize {
  @override
  AlbumOrganizeState build(User user) {
    final currentAlbumId = ref.watch(selectedAlbumProvider);
    final userAlbums = user.albums ?? [];

    return AlbumOrganizeState(currentAlbumId: currentAlbumId, user: user, userAlbums: userAlbums);
  }

  void updateTargetAlbumId(String? id) {
    state = state.copyWith(targetAlbumId: id);
  }

  void _setUploading(bool uploading) {
    state = state.copyWith(uploading: uploading);
  }

  void toggleFeed(String id) {
    final containFeed = state.ids.contains(id);

    if (containFeed) {
      state = state.copyWith(ids: state.ids.where((e) => e != id).toList());
    } else {
      state = state.copyWith(ids: [...state.ids, id]);
    }
  }

  /// 선택 삭제
  FutureOr<bool> deleteFeeds() async {
    if (state.uploading) {
      ToastService.showError('처리 중입니다. 잠시만 기다려주세요');
      return false;
    }

    if (state.ids.isEmpty) {
      ToastService.showError('삭제할 항목이 없습니다');
      return false;
    }

    _setUploading(true);

    try {
      final request = DeleteFeedsRequest(ids: state.ids);
      final result = await deleteFeedsUseCase.execute(request);

      final isSuccess = result.fold(
        onSuccess: (value) {
          ToastService.show('삭제가 완료되었습니다');
          return true;
        },
        onFailure: (e) {
          ToastService.showError('삭제가 실패되었습니다');
          return false;
        },
      );

      if (isSuccess) {
        ref.invalidate(albumFeedDataProvider(state.user.id, state.currentAlbumId));
        ref.invalidateSelf();
      }

      return isSuccess;
    } finally {
      _setUploading(false);
    }
  }

  /// 앨범 이동
  FutureOr<bool> moveFeeds() async {
    if (state.uploading) {
      ToastService.showError('처리 중입니다. 잠시만 기다려주세요');
      return false;
    }

    if (state.ids.isEmpty) {
      ToastService.showError('이동할 항목이 없습니다');
      return false;
    }

    if (state.targetAlbumId == '') {
      ToastService.showError('이동할 앨범을 선택해 주세요');
      return false;
    }

    _setUploading(true);

    try {
      final result =
          state.targetAlbumId == null
              ? await removeFeedsAlbumUseCase.execute(RemoveFeedsAlbumRequestParam(ids: state.ids))
              : await insertFeedToAlbumUseCase.execute(
                InsertFeedWithIdRequestParam(id: state.targetAlbumId!, param: InsertFeedRequestParam(ids: state.ids)),
              );

      final isSuccess = result.fold(
        onSuccess: (value) {
          ToastService.show('이동이 완료되었습니다');
          return true;
        },
        onFailure: (e) {
          ToastService.showError('이동이 실패되었습니다');
          return false;
        },
      );

      if (isSuccess) {
        ref.invalidate(albumFeedDataProvider(state.user.id, state.currentAlbumId));
        ref.invalidateSelf();
      }

      return isSuccess;
    } finally {
      _setUploading(false);
    }
  }
}

@freezed
abstract class AlbumOrganizeState with _$AlbumOrganizeState {
  const factory AlbumOrganizeState({
    // User
    required User user,
    // 현재 Album
    required String? currentAlbumId,
    // User Albums
    required List<Album> userAlbums,
    // 선택된 feed ids
    @Default([]) List<String> ids,
    // 이동할 앨범 id ('' -> 선택되지 않음)
    @Default('') String? targetAlbumId,
    // 서버 업로드 여부
    @Default(false) bool uploading,
  }) = _AlbumOrganizeState;
}

mixin class AlbumOrganizeMixin {
  AlbumOrganizeState albumOrganizeState(WidgetRef ref) {
    final user = ref.read(albumOrganizeUserArgumentProvider);
    return ref.watch(albumOrganizeProvider(user));
  }

  AlbumOrganize albumOrganizeNotifier(WidgetRef ref) {
    final user = ref.read(albumOrganizeUserArgumentProvider);
    return ref.read(albumOrganizeProvider(user).notifier);
  }
}
