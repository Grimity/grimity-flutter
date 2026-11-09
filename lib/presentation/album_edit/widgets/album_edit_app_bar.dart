// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/extensions/model/album_base_response.dart';
import 'package:grimity/presentation/album_edit/models/album_edit_model.dart';
import 'package:pervice/pervice.dart';

/// 앨범 편집 화면의 닫기와 저장 버튼을 표시하는 위젯.
class AlbumEditAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<AlbumEditModel> model;

  /// 현재 앨범 편집 상태.
  AlbumEditModel get data => model.value;

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.editor(
      onBack: context.pop,
      onMenu: null,
      action: .new(
        label: '저장',
        onTap: () => onSubmit(context),
        enabled: data.canSubmit,
      ),
      title: '앨범 편집',
    );
  }

  /// 앨범 추가, 이름 변경 및 삭제를 반영한 뒤 순서를 저장합니다.
  Future<void> onSubmit(BuildContext context) async {
    try {
      // 목록에서 제거한 앨범 삭제.
      for (final album in data.removedAlbums) {
        await DeleteAlbumsById(id: album.id).request();
      }

      // 기존 앨범의 이름 변경.
      for (final album in data.renamedAlbums) {
        final service = PatchAlbumsById(
          id: album.id,
          request: .new(name: album.name),
        );

        await service.request();
      }

      // 새 앨범을 추가하고 발급된 아이디 반영.
      for (final album in data.addedAlbums) {
        final response = await PostAlbums(request: .new(name: album.name)).request();
        final index = data.albums.indexOf(album);

        data.albums[index] = .new(
          id: response.id,
          name: album.name,
        );
      }

      // 최종 앨범 순서를 저장하고 사용자 앨범 목록 갱신.
      if (data.albums.length > 1) {
        await PutAlbumsOrder(request: .new(ids: data.albums.ids)).request();
      }

      await AppUser.refreshAlbums();

      if (context.mounted) {
        GdsToast.show('앨범을 저장했어요', status: .positive);
        model.notifyChanged();
      }
    } catch (_) {
      GdsToast.show('앨범을 저장하지 못했어요', status: .negative);
      rethrow;
    }
  }
}
