// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/album_organize/models/album_organize_model.dart';
import 'package:grimity/presentation/album_organize/views/show_album_move_modal.dart';
import 'package:pervice/pervice.dart';

/// 선택한 그림을 삭제하거나 다른 앨범으로 이동하는 액션 버튼을 표시하는 위젯.
class AlbumOrganizeActions extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<AlbumOrganizeModel> model;

  @override
  Widget build(BuildContext context) {
    final enabled = model.value.checkedFeeds.isNotEmpty;

    return Row(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        GdsButton.text(
          type: .solid,
          size: .lg,
          label: '선택 삭제',
          leadingIcon: .trashBinTrash,
          enabled: enabled,
          onTap: () {
            final ids = model.value.checkedFeeds;

            // 선택한 그림을 삭제 대상으로 옮기고 선택을 해제합니다.
            model.value.removedFeeds.addAll(ids);
            model.value.checkedFeeds.clear();
            model.notifyChanged();
          },
        ),

        GdsButton.text(
          type: .solid,
          size: .lg,
          label: '앨범 이동',
          leadingIcon: .forward,
          enabled: enabled,
          onTap: () async {
            // 이동할 앨범이 없을 경우.
            if (AppUser.albums.isEmpty) {
              GdsToast.show('그림을 이동하려면 앨범이 필요해요', status: .negative);
              return;
            }

            final isSuccess = await showAlbumMoveModal(
              context,
              from: model.value.parent,
              feedIds: model.value.checkedFeeds,
            );

            // 이동한 그림을 삭제 대상으로 옮기고 선택을 해제합니다.
            if (isSuccess == true) {
              final ids = model.value.checkedFeeds;

              model.value.movedFeeds.addAll(ids);
              model.value.checkedFeeds.clear();
              model.notifyChanged();
            }
          },
        ),
      ],
    );
  }
}
