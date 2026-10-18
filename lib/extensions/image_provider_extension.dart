import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// [ImageProvider]에 대한 유틸리티 확장.
extension ImageProviderExtension on ImageProvider {
  /// 이미지 파일명을 반환하며, 기기 사진에 이름이 없으면 식별자를 사용합니다.
  String get displayName {
    return switch (this) {
      AssetEntityImageProvider(:final entity) => entity.title ?? entity.id,
      ResponsiveImage(:final url) => Uri.parse(url).pathSegments.lastOrNull ?? '이미지',
      NetworkImage(:final url) => Uri.parse(url).pathSegments.lastOrNull ?? '이미지',
      AssetImage(:final assetName) => assetName.split('/').last,
      FileImage(:final file) => file.uri.pathSegments.last,
      _ => '이미지',
    };
  }
}
