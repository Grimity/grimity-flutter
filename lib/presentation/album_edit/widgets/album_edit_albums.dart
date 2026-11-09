// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/album_edit/models/album_edit_model.dart';
import 'package:grimity/presentation/album_edit/views/show_album_delete_alert.dart';
import 'package:grimity/presentation/album_edit/views/show_album_rename_modal.dart';
import 'package:grimity/presentation/album_edit/widgets/album_edit_empty_state.dart';
import 'package:pervice/pervice.dart';

/// 앨범 목록을 표시하고 이름 변경, 삭제 및 순서 변경을 제공하는 위젯.
class AlbumEditAlbums extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<AlbumEditModel> model;

  /// 현재 앨범 편집 상태.
  AlbumEditModel get data => model.value;

  @override
  Widget build(BuildContext context) {
    final sortMode = context.stateOf(() => false);

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            // 섹션 제목 표시
            GdsText(
              '앨범 목록',
              color: .textGrayBold,
              style: .label3,
            ),

            // 편집 모드 전환 버튼 표시
            GdsTransition.fadeThrough(
              alignment: .centerRight,
              value: sortMode.value,
              child: GdsButton.text(
                type: .borderless,
                variant: sortMode.value ? .primary : .assistive,
                size: .sm,
                label: sortMode.value ? '완료' : '순서 편집',
                onTap: sortMode.toogle,
                enabled: data.albums.isNotEmpty,
                trailingIcon: sortMode.value ? null : .sortHorizontal,
              ),
            ),
          ],
        ),

        // 앨범 목록 표시
        GdsTransition.fadeThrough(
          value: data.albums.isEmpty,
          child: Builder(
            builder: (context) {
              // 등록된 앨범이 아예 없을 경우.
              if (data.albums.isEmpty) {
                return const AlbumEditEmptyState();
              }

              return GdsReorderable(
                axis: .vertical,
                spacing: 8,
                onReorder: (oldIndex, newIndex) {
                  final album = data.albums.removeAt(oldIndex);
                  data.albums.insert(newIndex, album);
                  model.notifyChanged();
                },
                itemCount: data.albums.length,
                itemBuilder: (context, index) {
                  final album = data.albums[index];

                  return _AlbumField(
                    key: ValueKey(album),
                    index: index,
                    album: album,
                    model: model,
                    sortMode: sortMode.value,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 앨범에 대한 이름 변경 및 삭제 버튼을 표시하는 항목 위젯.
class _AlbumField extends StatelessWidget {
  const new({
    super.key,
    required this.index,
    required this.album,
    required this.model,
    required this.sortMode,
  });

  final int index;
  final AlbumBaseResponse album;
  final ValueState<AlbumEditModel> model;
  final bool sortMode;

  @override
  Widget build(BuildContext context) {
    return GdsGroup(
      text: album.name,
      initialText: album.name,
      status: sortMode ? .enabled : .delete,
      onTap: () => onRename(context),
      onHandleTap: sortMode ? null : () => onDelete(context),
      dragHandleBuilder: (context, child) {
        if (!sortMode) return child;

        return GdsReorderableDragHandle(
          index: index,
          child: child,
        );
      },
    );
  }

  /// 이름 변경 모달을 열고 이후 앨범 목록에 반영합니다.
  Future<void> onRename(BuildContext context) async {
    final newAlbumName = await showAlbumRenameModal(
      context,
      albumName: album.name,
    );

    // 사용자가 앨범 이름을 변경했을 경우.
    if (newAlbumName != null) {
      model.value.albums[index] = .new(id: album.id, name: newAlbumName.trim());
      model.notifyChanged();

      GdsToast.show('앨범 이름을 변경했어요', status: .positive);
    }
  }

  /// 삭제 여부를 확인한 뒤 앨범을 목록에서 제거합니다.
  Future<void> onDelete(BuildContext context) async {
    final isConfirmed = await showAlbumDeleteAlert(context);

    // 사용자가 앨범 삭제를 동의했을 경우.
    if (isConfirmed == true) {
      model.value.albums.remove(album);
      model.notifyChanged();

      GdsToast.show('앨범을 삭제했어요', status: .positive);
    }
  }
}
