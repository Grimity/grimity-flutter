import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// 업로드한 이미지의 저장 경로와 URL을 담는 레코드.
typedef ImageUploadResult = ({
  String url,
  String name,
});

/// 이미지 변환과 업로드를 처리합니다.
abstract class AppImage {
  static final _dio = Dio();

  /// 기기 사진을 WebP로 업로드하고 입력 순서대로 이미지 경로와 URL을 반환합니다.
  static Future<List<ImageUploadUrlResponse>> upload(
    List<AssetEntity> assets,
    ImageType type,
  ) async {
    if (assets.isEmpty) {
      return [];
    }

    final images = <({Uint8List bytes, GetImageUploadUrlRequest request})>[];

    // 실제 업로드할 WebP 파일로 변환한 뒤 크기 확인.
    for (final asset in assets) {
      final file = await asset.file;
      if (file == null) {
        throw StateError('이미지 파일을 읽을 수 없습니다.');
      }

      final bytes = await FlutterImageCompress.compressWithFile(
        file.path,
        format: .webp,
        quality: 95,
        minWidth: asset.orientatedWidth,
        minHeight: asset.orientatedHeight,
      );

      if (bytes == null) {
        throw StateError('이미지를 WebP로 변환할 수 없습니다.');
      }

      final image = await decodeImageFromList(bytes);
      images.add((
        bytes: bytes,
        request: .new(
          type: type,
          ext: .webp,
          width: image.width,
          height: image.height,
          fileName: asset.title,
        ),
      ));

      image.dispose();
    }

    final service = PostImagesGetUploadUrls(
      request: images.map((image) => image.request).toList(),
    );

    final urls = await service.request();

    // 발급된 URL에 인증 헤더 없이 이미지 바이트 업로드.
    for (var index = 0; index < images.length; index++) {
      final bytes = images[index].bytes;

      await _dio.put<void>(
        urls[index].uploadUrl,
        data: Stream.value(bytes),
        options: .new(
          contentType: 'image/webp',
          responseType: .plain,
          headers: {
            Headers.contentLengthHeader: bytes.length,
          },
        ),
      );
    }

    return urls;
  }

  /// 새 이미지는 업로드하고 기존 이미지는 재사용하여 입력 순서대로 저장 경로를 반환합니다.
  static Future<List<ImageUploadResult>> resolve(
    List<ImageProvider> images,
    ImageType type,
  ) async {
    final others = images.whereType<ResponsiveImage>().toList();
    final assets = images.whereType<AssetEntityImageProvider>().toList();
    final entities = assets.builder((e) => e.entity);
    final responses = await upload(entities, type);

    return [
      ...others.builder((e) => (url: e.url, name: e.name)),
      ...responses.builder((e) => (url: e.imageUrl, name: e.imageName)),
    ];
  }
}

/// [ImageUploadResult] 목록에 대한 유틸리티 확장.
extension ImageUploadResultExtension on List<ImageUploadResult> {
  /// 이미지 저장 경로 목록.
  List<String> get names {
    return builder((result) => result.name);
  }

  /// 이미지 URL 목록.
  List<String> get urls {
    return builder((result) => result.url);
  }
}
