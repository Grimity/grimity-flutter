import 'package:flutter/material.dart';

class AlbumEditView extends StatelessWidget {
  const AlbumEditView({
    super.key,
    required this.albumEditAppBar,
    required this.albumAddView,
    required this.albumEditListView,
  });

  final PreferredSizeWidget albumEditAppBar;
  final Widget albumAddView;
  final Widget albumEditListView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: albumEditAppBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(children: [albumAddView, albumEditListView]),
        ),
      ),
    );
  }
}
