import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';

part 'album_provider.g.dart';

@riverpod
Future<List<Album>> albums(Ref ref) async {
  final result = await getMyAlbumsUseCase.execute();
  return result.fold(
    onSuccess: (albums) => albums,
    onFailure: (_) => <Album>[],
  );
}

/// 전체 앨범이 포함된 앨범 리스트
@riverpod
Future<List<Album>> albumsWithAll(Ref ref) async {
  final base = await ref.watch(albumsProvider.future);
  const allAlbum = Album(id: 'all', name: '전체 앨범');
  return [allAlbum, ...base];
}