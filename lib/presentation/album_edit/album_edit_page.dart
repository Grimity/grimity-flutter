import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/presentation/album_edit/album_edit_view.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/view/album_add_view.dart';
import 'package:grimity/presentation/album_edit/view/album_edit_view.dart';
import 'package:grimity/presentation/album_edit/widget/album_edit_app_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlbumEditPage extends HookConsumerWidget {
  final List<Album> albums;

  const AlbumEditPage({super.key, required this.albums});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(albumEditProvider.notifier).updateAlbums(albums));
      return null;
    });

    return AlbumEditView(
      albumEditAppBar: AlbumEditAppBar(),
      albumAddView: AlbumAddView(),
      albumEditListView: AlbumEditListView(),
    );
  }
}
