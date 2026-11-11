// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/album_organize/models/album_organize_model.dart';

/// 그림 정리 화면의 뒤로 가기와 저장 기능을 제공하는 위젯.
class AlbumOrganizeAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final AlbumOrganizeModel model;

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.editor(
      onBack: context.pop,
      onMenu: null,
      action: .new(
        label: '저장',
        onTap: () => onSubmit(context),
        enabled: model.canSubmit,
      ),
      title: '그림 정리',
    );
  }

  /// 삭제할 그림과 변경한 앨범 이름을 저장합니다.
  Future<void> onSubmit(BuildContext context) async {
    try {
      if (model.removedFeeds.isNotEmpty) {
        await PostFeedsBatchDelete(request: .new(ids: model.removedFeeds)).request();
      }

      if (model.hasChanges) {
        await PatchAlbumsById(
          id: model.albumId,
          request: .new(name: model.albumName),
        ).request();
      }

      await AppUser.refreshAlbums();

      if (context.mounted) {
        GdsToast.show('그림 정리를 저장했어요', status: .positive);
        context.pop(true);
      }
    } catch (_) {
      GdsToast.show('그림 정리를 저장하지 못했어요', status: .negative);
      rethrow;
    }
  }
}
