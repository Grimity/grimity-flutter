// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/album_edit/models/album_edit_model.dart';
import 'package:grimity/presentation/album_edit/widgets/album_edit_albums.dart';
import 'package:grimity/presentation/album_edit/widgets/album_edit_app_bar.dart';
import 'package:grimity/presentation/album_edit/widgets/album_edit_add_field.dart';
import 'package:pervice/pervice.dart';

/// 앨범 추가, 이름 변경, 삭제 및 순서 변경을 제공하는 앨범 편집 페이지.
class AlbumEditPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.stateOf(AlbumEditModel.from);

    return GdsScaffold(
      appBar: AlbumEditAppBar(model: model),
      body: SingleChildScrollView(
        padding: context.whenDevice(
          mobile: .symmetric(vertical: 16, horizontal: 16),
          tablet: .symmetric(vertical: 24, horizontal: 20),
        ),
        child: Column(
          mainAxisSize: .min,
          spacing: 32,
          children: [
            // 새 앨범 추가 입력 필드 표시.
            AlbumEditAddField(model: model),

            // 편집할 앨범 목록 표시.
            AlbumEditAlbums(model: model),
          ],
        ),
      ),
    );
  }
}
