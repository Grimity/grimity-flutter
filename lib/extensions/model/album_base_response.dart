// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';

/// [AlbumBaseResponse] 목록에 대한 유틸리티 확장.
extension AlbumBaseResponseListExtension on List<AlbumBaseResponse> {
  /// 앨범 목록의 아이디 목록.
  List<String> get ids => builder((e) => e.id);

  /// 앨범 목록의 이름 목록.
  List<String> get names => builder((e) => e.name);
}
