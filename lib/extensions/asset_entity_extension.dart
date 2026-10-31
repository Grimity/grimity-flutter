// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// [AssetEntity]에 대한 유틸리티 확장.
extension AssetEntityExtension on AssetEntity {
  /// 기기 사진을 표시할 이미지 제공자를 생성합니다.
  ImageProvider toImage() {
    return AssetEntityImageProvider(this);
  }
}
