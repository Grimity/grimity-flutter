import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class AlbumEditView extends StatelessWidget {
  const AlbumEditView({
    super.key,
    required this.albumEditAppBar,
    required this.albumEditDrawer,
    required this.albumAddView,
    required this.albumEditListView,
  });

  final Widget albumEditAppBar;
  final Widget albumEditDrawer;
  final Widget albumAddView;
  final Widget albumEditListView;

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: albumEditAppBar,
      drawer: albumEditDrawer,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            spacing: GdsSpacing.spacing32,
            children: [
              albumAddView,
              albumEditListView,
            ],
          ),
        ),
      ),
    );
  }
}
