// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:pervice/pervice.dart';

/// 선택한 그림을 다른 앨범으로 이동하거나 앨범에서 제외하는 모달을 엽니다.
Future<bool?> showAlbumMoveModal(
  BuildContext context, {
  required AlbumWithCountResponse from,
  required List<String> feedIds,
}) {
  return GdsAdaptiveModal.show(
    context,
    builder: (context) {
      final selectedAlbum = context.stateOf<AlbumBaseResponse?>(() => null);
      final albums = AppUser.albums.where((e) => e.id != from.id).toList();

      // 그림을 다른 앨범으로 옮기거나 앨범에서 제외합니다.
      void onSubmit() async {
        final albumId = selectedAlbum.value?.id;

        if (albumId != null) {
          final service = PutAlbumsById(
            id: albumId,
            request: .new(ids: feedIds),
          );

          await service.request();

          GdsToast.show('그림을 다른 앨범으로 이동했어요', status: .positive);
        } else {
          final service = PutAlbumsNull(request: .new(ids: feedIds));
          await service.request();

          GdsToast.show('그림을 앨범에서 제외했어요', status: .positive);
        }

        if (context.mounted) {
          context.pop(true);
        }
      }

      return .new(
        title: '앨범 이동',
        primaryButton: .new(
          label: '이동하기',
          onTap: onSubmit,
        ),
        secondaryButton: .new(
          label: '닫기',
          onTap: context.pop,
        ),
        children: [
          GdsListItem.optionCard(
            label: '전체',
            status: .from(selected: selectedAlbum.hasNoValue),
            onTap: () {
              // 그림을 앨범에서 제외하도록 합니다.
              selectedAlbum.value = null;
            },
          ),

          ...albums.builder((album) {
            return GdsListItem.optionCard(
              label: album.name,
              status: .from(selected: selectedAlbum.value == album),
              onTap: () {
                // 이동할 대상 앨범을 선택합니다.
                selectedAlbum.value = album;
              },
            );
          }),
        ],
      );
    },
  );
}
