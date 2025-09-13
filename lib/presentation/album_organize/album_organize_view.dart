import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumOrganizeView extends ConsumerWidget {
  const AlbumOrganizeView({
    super.key,
    required this.albumOrganizeAppBar,
    required this.albumOrganizeBodyView,
    required this.albumOrganizeFabView,
  });

  final PreferredSizeWidget albumOrganizeAppBar;
  final Widget albumOrganizeBodyView;
  final Widget albumOrganizeFabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: albumOrganizeAppBar,
      body: albumOrganizeBodyView,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: albumOrganizeFabView,
    );
  }
}
