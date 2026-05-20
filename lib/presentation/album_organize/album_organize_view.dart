import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';

class AlbumOrganizeView extends ConsumerWidget {
  const AlbumOrganizeView({
    super.key,
    required this.albumOrganizeAppBar,
    required this.albumOrganizeBodyView,
    required this.albumOrganizeFabView,
  });

  final Widget albumOrganizeAppBar;
  final Widget albumOrganizeBodyView;
  final Widget albumOrganizeFabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsScaffold(
      appBar: albumOrganizeAppBar,
      body: albumOrganizeBodyView,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: albumOrganizeFabView,
    );
  }
}
