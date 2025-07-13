import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/exception/album_name_conflict_exception.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/usecase/album_usecases.dart';
import 'package:grimity/presentation/album_edit/provider/album_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_edit_provider.g.dart';

part 'album_edit_provider.freezed.dart';

@riverpod
class AlbumEdit extends _$AlbumEdit {
  @override
  AlbumEditState build() {
    return AlbumEditState();
  }

  // 새 앨범 이름 업데이트
  void updateNewAlbumName(String value) {
    state = state.copyWith(newAlbumName: value);
  }

  // 앨범 순서 편집 토글
  void toggleIsAlbumSorting() {
    if (state.isAlbumSorting) {
      _saveAlbumOrder();
    }
    state = state.copyWith(isAlbumSorting: !state.isAlbumSorting);
  }

  // 앨범 업데이트
  void updateAlbums(List<Album> albums) {
    state = state.copyWith(albums: albums);
  }

  // 앨범 하나 수정
  void updateAlbumByOne(String id, String name) {
    state = state.copyWith(albums: state.albums.map((e) => e.id == id ? e.copyWith(name: name) : e).toList());
  }

  // 수정 앨범 업데이트
  void updateEditAlbum(Album album) {
    // 수정중인 앨범이 있을때 원복 처리
    state = state.copyWith(
      editAlbum: album,
      albums:
          state.editAlbum != null
              ? state.albums.map((e) => e.id == state.editAlbum!.id ? state.editAlbum! : e).toList()
              : state.albums,
    );
  }

  // 앨범 수정 취소
  void cancelEditAlbum() {
    if (state.editAlbum != null) {
      state = state.copyWith(
        editAlbum: null,
        albums: state.albums.map((e) => e.id == state.editAlbum!.id ? state.editAlbum! : e).toList(),
      );
    }
  }

  // 앨범 이름 체크
  void _checkNewAlbumName() {
    if (!ValidatorUtil.isValidAlbumName(state.newAlbumName)) {
      state = state.copyWith(
        isNewAlbumNameChecking: false,
        newAlbumNameState: GrimityTextFieldState.error,
        albumCheckMessage: '앨범명 최대 15자까지만 가능해요',
      );
      return;
    }

    state = state.copyWith(isNewAlbumNameChecking: true, newAlbumNameState: GrimityTextFieldState.normal);
  }

  // 앨범 추가
  Future<void> createNewAlbum() async {
    _checkNewAlbumName();
    if (state.isNewAlbumNameChecking == false) {
      return;
    }

    final result = await createAlbumUseCase.execute(CreateAlbumRequestParam(name: state.newAlbumName));

    result.fold(
      onSuccess: (value) {
        state = state.copyWith(newAlbumName: '', newAlbumNameState: GrimityTextFieldState.normal);

        ref.invalidate(albumDataProvider);
      },
      onFailure: (e) {
        if (e is AlbumNameConflictException) {
          state = state.copyWith(
            isNewAlbumNameChecking: false,
            newAlbumNameState: GrimityTextFieldState.error,
            albumCheckMessage: '중복된 이름은 사용하실 수 없어요',
          );
        } else {
          state = state.copyWith(
            isNewAlbumNameChecking: false,
            newAlbumNameState: GrimityTextFieldState.error,
            albumCheckMessage: '',
          );
          ToastService.showError('앨범 추가에 에러가 발생했어요');
        }
      },
    );
  }

  // 앨범 순서 저장
  Future<void> _saveAlbumOrder() async {
    final List<String> ids = state.albums.map((e) => e.id).toList();
    final result = await updateAlbumOrderUseCase.execute(UpdateAlbumOrderRequestParam(ids: ids));

    result.fold(
      onSuccess: (value) {
        ref.invalidate(albumDataProvider);
      },
      onFailure: (e) {
        ToastService.showError('앨범 순서 저장에 실패했어요');
      },
    );
  }

  // 앨범 삭제
  Future<void> deleteAlbum(Album album) async {
    final result = await deleteAlbumUseCase.execute(album.id);

    result.fold(
      onSuccess: (value) {
        ref.invalidate(albumDataProvider);
      },
      onFailure: (e) {
        ToastService.showError('앨범 삭제에 실패했어요');
      },
    );
  }

  // 앨범 수정
  Future<void> updateAlbum(Album album) async {
    if (!ValidatorUtil.isValidAlbumName(album.name)) {
      ToastService.showError('앨범명 최대 15자까지만 가능해요');
      return;
    }

    final result = await updateAlbumUseCase.execute(
      UpdateAlbumWithIdRequestParam(id: album.id, param: UpdateAlbumRequestParam(name: album.name)),
    );

    result.fold(
      onSuccess: (value) {
        state = state.copyWith(editAlbum: null);
        ref.invalidate(albumDataProvider);
      },
      onFailure: (e) {
        if (e is AlbumNameConflictException) {
          ToastService.showError('중복된 이름은 사용하실 수 없어요');
        } else {
          ToastService.showError('앨범 수정에 실패했어요');
        }
      },
    );
  }
}

/// 앨범 편집 상태 클래스
@freezed
abstract class AlbumEditState with _$AlbumEditState {
  const factory AlbumEditState({
    @Default('') String newAlbumName,
    @Default(GrimityTextFieldState.normal) GrimityTextFieldState newAlbumNameState,
    @Default(false) bool isNewAlbumNameChecking,
    String? albumCheckMessage,
    @Default(false) bool isAlbumSorting,
    Album? editAlbum,
    @Default([]) List<Album> albums,
  }) = _AlbumEditState;
}
