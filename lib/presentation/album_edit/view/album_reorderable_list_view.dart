import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/widget/album_delete_dialog.dart';
import 'package:grimity/presentation/album_edit/widget/album_edit.dart';

class AlbumReorderableListView extends ConsumerWidget {
  const AlbumReorderableListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumEditState = ref.watch(albumEditProvider);
    final albums = albumEditState.albums;
    final isSorting = albumEditState.isAlbumSorting;

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

        return Padding(
          key: ValueKey('album-${album.id}'),
          padding: EdgeInsets.only(bottom: index == albums.length - 1 ? 0 : GdsSpacing.spacing8),
          child: GdsGroupSetting(
            text: album.name,
            state: isSorting ? GdsGroupSettingState.enabled : GdsGroupSettingState.editDelete,
            onTap: isSorting ? null : () => showAlbumDeleteDialog(context, ref, album),
            onEditTap: () => showAlbumEdit(context, album, ref),
          ),
        );
      },
    );
  }
}
