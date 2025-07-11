import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_data_provider.g.dart';

@riverpod
class AlbumData extends _$AlbumData {
  @override
  FutureOr<List<Album>> build() async {
    final result = await getMyAlbumsUseCase.execute();

    return result.fold(
      onSuccess: (albums) {
        ref.read(albumEditProvider.notifier).updateAlbums(albums);
        return albums;
      },
      onFailure: (e) {
        ref.read(albumEditProvider.notifier).updateAlbums([]);
        return [];
      },
    );
  }
}
