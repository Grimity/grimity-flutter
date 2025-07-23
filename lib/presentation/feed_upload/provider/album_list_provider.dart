import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_list_provider.g.dart';

@riverpod
class AlbumList extends _$AlbumList {
  @override
  FutureOr<List<Album>> build() async {
    final result = await getMyAlbumsUseCase.execute();
    final allAlbum = Album(id: 'all', name: '전체 앨범');

    return result.fold(
      onSuccess: (albums) {
        return [allAlbum, ...albums];
      },
      onFailure: (e) {
        return [allAlbum];
      },
    );
  }
}
