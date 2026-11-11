// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/album_edit/views/show_album_rename_modal.dart';
import 'package:grimity/presentation/album_organize/models/album_organize_model.dart';
import 'package:pervice/components/value_state.dart';

/// 앨범 이름과 이름 변경 액션 버튼을 표시하는 헤더 위젯.
class AlbumOrganizeHeader extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<AlbumOrganizeModel> model;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          // 앨범 이름 표시
          GdsText(
            model.value.albumName,
            color: .textGrayBold,
            style: context.whenDevice(
              mobile: .title2,
              tablet: .title1,
            ),
          ),

          // 앨범명 수정 버튼 표시
          GdsButton.text(
            size: .md,
            type: .borderless,
            variant: .assistive,
            trailingIcon: .pen2,
            label: '앨범명 변경',
            onTap: () => onRename(context),
          ),
        ],
      ),
    );
  }

  /// 이름 변경 모달을 열고 이후 앨범 목록에 반영합니다.
  void onRename(BuildContext context) async {
    final newAlbumName = await showAlbumRenameModal(
      context,
      initialName: model.value.albumName,
    );

    // 사용자가 앨범 이름을 변경했을 경우.
    if (newAlbumName != null) {
      model.value = model.value.copyWith(albumName: newAlbumName);
    }
  }
}
