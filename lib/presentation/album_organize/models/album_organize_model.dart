// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/api/api.dart';

/// 앨범 목록 편집에 필요한 입력 데이터를 관리하는 모델.
class AlbumOrganizeModel({
  required final AlbumWithCountResponse parent,
  required final String albumId,
  required final String albumName,
}) {
  final List<String> checkedFeeds = [];
  final List<String> removedFeeds = [];
  final List<String> movedFeeds = [];

  /// 초기 입력값과 비교하여 변경된 내용이 있는지 여부.
  bool get hasChanges => parent.name != albumName;

  /// 필수 입력값을 충족하고 변경된 내용이 있어 제출할 수 있는지 여부.
  bool get canSubmit {
    return removedFeeds.isNotEmpty || hasChanges;
  }

  /// 해당 그림이 현재 선택되었는지 여부를 반환합니다.
  bool isChecked(UserFeedResponse feed) {
    return checkedFeeds.contains(feed.id);
  }

  /// 지정한 값을 반영한 새 모델을 반환합니다.
  AlbumOrganizeModel copyWith({
    AlbumWithCountResponse? parent,
    String? albumId,
    String? albumName,
  }) {
    return .new(
        parent: parent ?? this.parent,
        albumId: albumId ?? this.albumId,
        albumName: albumName ?? this.albumName,
      )
      ..checkedFeeds.addAll(checkedFeeds)
      ..removedFeeds.addAll(removedFeeds)
      ..movedFeeds.addAll(movedFeeds);
  }
}
