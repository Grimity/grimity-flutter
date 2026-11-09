// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/foundation.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/extensions/model/album_base_response.dart';

/// 앨범의 식별자와 편집할 이름. 새 앨범은 식별자가 없습니다.
typedef AlbumEditItem = ({String? id, String name});

/// 앨범 목록 편집에 필요한 입력 데이터를 관리하는 모델.
class AlbumEditModel({
  required final List<AlbumBaseResponse> albums,
}) {
  factory from() {
    return .new(
      albums: AppUser.albums.toList(),
    );
  }

  /// 초기 목록 또는 서버에 반영된 목록과 다른 내용이 있는지 여부.
  bool get hasChanges {
    final oldNames = AppUser.albums.names;
    final newNames = albums.names;

    return !listEquals(oldNames, newNames);
  }

  /// 변경된 내용이 있어 제출할 수 있는지 여부.
  bool get canSubmit => hasChanges;

  /// 기존 앨범 중 편집 목록에서 제거된 앨범.
  List<AlbumBaseResponse> get removedAlbums {
    return AppUser.albums.where((old) => !albums.ids.contains(old.id)).toList();
  }

  /// 기존 앨범 중 편집 목록에서 추가된 앨범.
  List<AlbumBaseResponse> get addedAlbums {
    return albums.where((e) => e.id.isEmpty).toList();
  }

  /// 기존 앨범 중 편집 목록에서 수정된 앨범.
  List<AlbumBaseResponse> get renamedAlbums {
    return albums.where((album) => AppUser.albums.any((old) => old.id == album.id && old.name != album.name)).toList();
  }
}
