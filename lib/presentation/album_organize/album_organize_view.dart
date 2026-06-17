import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';

class AlbumOrganizeView extends ConsumerWidget {
  const AlbumOrganizeView({
    super.key,
    required this.albumOrganizeAppBar,
    required this.albumOrganizeDrawer,
    required this.albumOrganizeBodyView,
    required this.albumOrganizeFabView,
  });

  final Widget albumOrganizeAppBar;
  final Widget albumOrganizeDrawer;
  final Widget albumOrganizeBodyView;
  final Widget albumOrganizeFabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsScaffold(
      appBar: albumOrganizeAppBar,
      drawer: albumOrganizeDrawer,
      body: albumOrganizeBodyView,
    );
  }
}
