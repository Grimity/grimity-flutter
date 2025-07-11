import 'package:flutter/material.dart';
import 'package:grimity/presentation/album_edit/album_edit_view.dart';
import 'package:grimity/presentation/album_edit/view/album_add_view.dart';
import 'package:grimity/presentation/album_edit/view/album_edit_view.dart';
import 'package:grimity/presentation/album_edit/widget/album_edit_app_bar.dart';

class AlbumEditPage extends StatelessWidget {
  const AlbumEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlbumEditView(
      albumEditAppBar: AlbumEditAppBar(),
      albumAddView: AlbumAddView(),
      albumEditListView: AlbumEditListView(),
    );
  }
}
