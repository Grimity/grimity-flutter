import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/exception/album_name_conflict_exception.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/domain/dto/album_request_params.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/usecase/album_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_edit_provider.g.dart';

part 'album_edit_provider.freezed.dart';

@riverpod
class AlbumEdit extends _$AlbumEdit {
  static const _tempAlbumIdPrefix = 'temp-album-';

  List<Album> _initialAlbums = [];
  int _tempAlbumIdSeed = 0;

  @override
  AlbumEditState build() {
    return AlbumEditState();
  }

  bool get hasUnsavedChanges => !_isSameAlbumList(_initialAlbums, state.albums);

  bool get canSave => hasUnsavedChanges && !state.isAlbumSorting;

  void initializeAlbums(List<Album> albums) {
    if (hasUnsavedChanges && _initialAlbums.isNotEmpty) {
      return;
    }

    _initialAlbums = List<Album>.from(albums);
    _tempAlbumIdSeed = 0;
    state = state.copyWith(
      newAlbumName: '',
      newAlbumNameState: GrimityTextFieldState.normal,
      isNewAlbumNameChecking: false,
      albumCheckMessage: null,
      isAlbumSorting: false,
      editAlbum: null,
      albums: List<Album>.from(albums),
    );
  }

  // 새 앨범 이름 업데이트
  void updateNewAlbumName(String value) {
    state = state.copyWith(newAlbumName: value);
  }

  // 앨범 순서 편집 토글
  void toggleIsAlbumSorting() {
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
  void createNewAlbum() {
    _checkNewAlbumName();
    if (state.isNewAlbumNameChecking == false) {
      return;
    }

    if (_hasDuplicateName(state.newAlbumName)) {
      state = state.copyWith(
        isNewAlbumNameChecking: false,
        newAlbumNameState: GrimityTextFieldState.error,
        albumCheckMessage: '중복된 이름은 사용하실 수 없어요',
      );
      return;
    }

    final newAlbum = Album(id: _nextTempAlbumId(), name: state.newAlbumName.trim());
    state = state.copyWith(
      newAlbumName: '',
      newAlbumNameState: GrimityTextFieldState.normal,
      isNewAlbumNameChecking: false,
      albumCheckMessage: null,
      albums: [...state.albums, newAlbum],
    );
  }

  // 앨범 삭제
  void deleteAlbum(Album album) {
    state = state.copyWith(albums: state.albums.where((a) => a.id != album.id).toList());
  }

  // 앨범 수정
  bool updateAlbum(Album album) {
    final name = album.name.trim();

    if (!ValidatorUtil.isValidAlbumName(name)) {
      ToastService.showFailure('앨범명 최대 15자까지만 가능해요');
      return false;
    }

    if (_hasDuplicateName(name, excludingId: album.id)) {
      ToastService.showFailure('중복된 이름은 사용하실 수 없어요');
      return false;
    }

    final updated = state.albums.map((item) => item.id == album.id ? album.copyWith(name: name) : item).toList();
    state = state.copyWith(albums: updated, editAlbum: null);
    return true;
  }

  Future<bool> saveChanges() async {
    if (!hasUnsavedChanges) {
      return true;
    }

    if (!_validateAlbumsBeforeSave()) {
      return false;
    }

    var committedAlbums = List<Album>.from(state.albums);
    final initialById = {for (final album in _initialAlbums) album.id: album};
    final currentExistingIds = committedAlbums.where((album) => !_isTempAlbum(album)).map((album) => album.id).toSet();

    try {
      for (final album in _initialAlbums.where((album) => !currentExistingIds.contains(album.id))) {
        await _throwIfFailure(deleteAlbumUseCase.execute(album.id));
      }

      for (final album in committedAlbums.where(_isTempAlbum)) {
        final result = await createAlbumUseCase.execute(CreateAlbumRequestParam(name: album.name));
        final createdId = result.getOrThrow().id;
        committedAlbums =
            committedAlbums.map((item) => item.id == album.id ? item.copyWith(id: createdId) : item).toList();
      }

      for (final album in committedAlbums.where((album) {
        final initialAlbum = initialById[album.id];
        return initialAlbum != null && initialAlbum.name != album.name;
      })) {
        await _throwIfFailure(
          updateAlbumUseCase.execute(
            UpdateAlbumWithIdRequestParam(id: album.id, param: UpdateAlbumRequestParam(name: album.name)),
          ),
        );
      }

      final orderIds = committedAlbums.map((album) => album.id).toList();
      if (orderIds.isNotEmpty && !_isSameStringList(_initialAlbums.map((album) => album.id).toList(), orderIds)) {
        await _throwIfFailure(updateAlbumOrderUseCase.execute(UpdateAlbumOrderRequestParam(ids: orderIds)));
      }

      _initialAlbums = List<Album>.from(committedAlbums);
      state = state.copyWith(albums: committedAlbums, isAlbumSorting: false);
      ToastService.showSuccess('앨범 수정이 완료되었습니다');
      return true;
    } on AlbumNameConflictException {
      ToastService.showFailure('중복된 이름은 사용하실 수 없어요');
      return false;
    } catch (_) {
      ToastService.showFailure('앨범 수정에 실패했어요');
      return false;
    }
  }

  bool _validateAlbumsBeforeSave() {
    for (final album in state.albums) {
      if (!ValidatorUtil.isValidAlbumName(album.name)) {
        ToastService.showFailure('앨범명 최대 15자까지만 가능해요');
        return false;
      }
    }

    final names = <String>{};
    for (final album in state.albums) {
      final normalized = album.name.trim();
      if (!names.add(normalized)) {
        ToastService.showFailure('중복된 이름은 사용하실 수 없어요');
        return false;
      }
    }

    return true;
  }

  bool _hasDuplicateName(String name, {String? excludingId}) {
    final normalized = name.trim();
    return state.albums.any((album) => album.id != excludingId && album.name.trim() == normalized);
  }

  String _nextTempAlbumId() {
    _tempAlbumIdSeed += 1;
    return '$_tempAlbumIdPrefix$_tempAlbumIdSeed';
  }

  bool _isTempAlbum(Album album) {
    return album.id.startsWith(_tempAlbumIdPrefix);
  }

  bool _isSameAlbumList(List<Album> a, List<Album> b) {
    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].name != b[i].name) {
        return false;
      }
    }

    return true;
  }

  bool _isSameStringList(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }

  Future<void> _throwIfFailure(FutureOr<Result<void>> result) async {
    final resolved = await result;
    resolved.fold(
      onSuccess: (_) {},
      onFailure: (e) => throw e,
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
