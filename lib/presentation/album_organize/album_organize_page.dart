import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/album_organize/album_organize_view.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_page_argument_provider.dart';
import 'package:grimity/presentation/album_organize/view/album_organize_body_view.dart';
import 'package:grimity/presentation/album_organize/view/album_organize_fab_view.dart';
import 'package:grimity/presentation/album_organize/widget/album_organize_app_bar.dart';

/// 그림 정리 Page
class AlbumOrganizePage extends ConsumerWidget {
  final User user;

  const AlbumOrganizePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [albumOrganizeUserArgumentProvider.overrideWithValue(user)],
      child: AlbumOrganizeView(
        albumOrganizeAppBar: AlbumOrganizeAppBar(),
        albumOrganizeBodyView: AlbumOrganizeBodyView(),
        albumOrganizeFabView: AlbumOrganizeFabView(),
      ),
    );
  }
}
