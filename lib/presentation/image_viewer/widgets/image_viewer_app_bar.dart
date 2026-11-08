// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_photo.dart';
import 'package:photo_manager/photo_manager.dart';

/// 이미지 뷰어 상단에 닫기와 다운로드 같은 액션 버튼을 표시하는 위젯.
class ImageViewerAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.imageUrls,
    required this.controller,
    required this.canDownload,
  });

  final List<String> imageUrls;
  final TabController controller;
  final bool canDownload;

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.imageViewer(
      onBack: context.pop,
      onDownload: onDownload,
      canDownload: canDownload,
    );
  }

  /// 현재 보고 있는 이미지를 다운로드하여 갤러리에 저장합니다.
  Future<void> onDownload() async {
    if (imageUrls.isEmpty) return;

    final url = imageUrls[controller.index];
    final dio = Api.dio;

    try {
      final hasAccess = await AppPhoto.requestPermission();

      // 사진 접근 권한이 없는 경우.
      if (!hasAccess) {
        GdsToast.show('사진 저장 권한을 허용해 주세요', status: .negative);
        return;
      }

      // 원본 이미지를 바이트 배열로 다운로드.
      final response = await dio.get<List<int>>(
        url,
        options: .new(responseType: .bytes),
      );

      final bytes = response.data;

      // 다운로드한 내용이 없거나 비어있을 경우.
      if (bytes == null || bytes.isEmpty) {
        throw StateError('이미지를 다운로드할 수 없습니다.');
      }

      // URL 경로의 마지막 부분을 파일명으로 사용하며, 쿼리 파라미터는 제외.
      final filename = Uri.parse(url).pathSegments.last;

      // 다운로드한 이미지를 갤러리에 저장.
      await PhotoManager.editor.saveImage(
        .fromList(bytes),
        filename: filename,
      );

      GdsToast.show('이미지를 저장했어요', status: .positive);
    } catch (_) {
      GdsToast.show('이미지를 저장하지 못했어요', status: .negative);
      rethrow;
    } finally {
      dio.close();
    }
  }
}
