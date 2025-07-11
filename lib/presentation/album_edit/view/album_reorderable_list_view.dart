import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/widget/album_widget.dart';

class AlbumReorderableListView extends ConsumerWidget {
  const AlbumReorderableListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumEditState = ref.watch(albumEditProvider);
    final albums = albumEditState.albums;

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: albums.length,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Material(elevation: 0, color: Colors.transparent, child: child);
          },
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final albumList = List<Album>.from(albums);
        final item = albumList.removeAt(oldIndex);
        albumList.insert(newIndex, item);
        ref.read(albumEditProvider.notifier).updateAlbums(albumList);
      },
      itemBuilder: (context, index) {
        final album = albums[index];
        final isEditing = album.id == albumEditState.editAlbum?.id;

        return AlbumWidget(
          key: ValueKey('album-${album.id}'),
          album: album,
          index: index,
          isEditing: isEditing,
          showSuffix: albumEditState.isAlbumSorting ? false : true,
        );
      },
    );
  }
}
