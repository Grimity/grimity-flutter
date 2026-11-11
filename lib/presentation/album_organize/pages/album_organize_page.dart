// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/album_organize/models/album_organize_model.dart';
import 'package:grimity/presentation/album_organize/widgets/album_organize_actions.dart';
import 'package:grimity/presentation/album_organize/widgets/album_organize_albums.dart';
import 'package:grimity/presentation/album_organize/widgets/album_organize_app_bar.dart';
import 'package:grimity/presentation/album_organize/widgets/album_organize_count.dart';
import 'package:grimity/presentation/album_organize/widgets/album_organize_header.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 앨범 내의 피드를 선택해 삭제하거나 다른 앨범으로 이동하는 페이지.
class AlbumOrganizePage extends StatelessWidget {
  const new({
    super.key,
    required this.album,
  });

  /// 그림을 정리할 대상 앨범.
  final AlbumWithCountResponse album;

  @override
  Widget build(BuildContext context) {
    final model = context.stateOf(
      () => AlbumOrganizeModel(
        parent: album,
        albumId: album.id,
        albumName: album.name,
      ),
    );

    return GdsScaffold(
      appBar: AlbumOrganizeAppBar(model: model.value),
      body: Stack(
        children: [
          SliverScrollView(
            padding: context.whenDevice(
              mobile: const .all(16),
              tablet: const .symmetric(vertical: 24, horizontal: 20),
            ),
            slivers: [
              // 헤더 표시
              AlbumOrganizeHeader(model: model),
              SliverGap(
                context.whenDevice(
                  mobile: 16,
                  tablet: 12,
                ),
              ),

              // 앨범 피드 개수 표시
              AlbumOrganizeCount(count: album.feedCount.toInt()),
              const SliverGap(12),

              // 앨범 목록 표시
              AlbumOrganizeAlbums(model: model),
            ],
          ),

          // 액션 버튼 표시
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: AlbumOrganizeActions(model: model),
          ),
        ],
      ),
    );
  }
}
