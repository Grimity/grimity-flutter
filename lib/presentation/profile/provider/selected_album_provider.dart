import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_album_provider.g.dart';

@riverpod
class SelectedAlbum extends _$SelectedAlbum {
  @override
  String? build() {
    // null -> 전체
    // albumId -> 해당 앨범
    return null;
  }

  void selectAlbum(String? albumId) {
    state = albumId;
  }

  void selectAll() {
    state = null;
  }
}
