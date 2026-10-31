// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';

/// 피드를 업로드할 앨범을 선택하는 팝업을 표시합니다.
Future<AlbumBaseResponse?> showFeedUploadAlbumSelectAlert(
  BuildContext context,
  AlbumBaseResponse? selectedAlbum,
) async {
  return GdsAdaptiveModal.show<AlbumBaseResponse>(
    context,
    builder: (context) => GdsAdaptiveModal(
      title: '앨범명 변경',
      children: AppUser.albums.builder((album) {
        final isSelected = album.id == selectedAlbum?.id;

        return GdsListItem.optionCard(
          status: isSelected ? .selected : .enabled,
          label: album.name,

          // 선택되지 않은 앨범을 누르면 반환하고 팝업 닫기.
          onTap: isSelected ? null : () => context.pop(album),
        );
      }),
    ),
  );
}
