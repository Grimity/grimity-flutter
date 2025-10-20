import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grimity/app/enum/presigned.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';
import 'package:grimity/domain/usecase/image_usecases.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageUpload {
  static Future<List<ImageUploadUrl>> uploadAssets(
    List<ImageSourceItem> images,
    PresignedType type,
  ) async {
    final imageAssets = images.whereType<AssetImageSource>().map((e) => e.asset).toList();
    if (imageAssets.isEmpty) return [];

    final urlRequests = List.filled(
      imageAssets.length,
      GetImageUploadUrlRequest(type: type, ext: PresignedExt.webp),
    );

    final urlResult = await getImageUploadUrlsUseCase.execute(urlRequests);
    if (urlResult.isFailure) {
      ToastService.showError('이미지 업로드 주소 생성에 실패했습니다.');
      return [];
    }

    // 2. AssetEntity -> XFile 변환 (임시 파일 생성)
    final xFileList = await _assetEntitiesToXFiles(imageAssets);
    if (xFileList.contains(null)) {
      ToastService.showError('이미지 파일을 읽을 수 없습니다.');
      return [];
    }

    // 3. AWS 이미지 업로드
    final uploadRequests = List.generate(
      urlResult.data.length,
      (index) => UploadImageRequest(url: urlResult.data[index].uploadUrl, filePath: xFileList[index]!.path),
    );

    final uploadResult = await uploadImagesUseCase.execute(uploadRequests);
    if (uploadResult.isFailure) {
      ToastService.showError('문제가 발생하였습니다.');
      return [];
    }

    return urlResult.data.toList();
  }

  /// AssetEntity List -> XFile List
  /// 파일 접근 불가(삭제 등)시 null 포함
  static Future<List<XFile?>> _assetEntitiesToXFiles(List<AssetEntity> assets) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    return Future.wait(
      assets.map((asset) async {
        final file = await asset.file;
        if (file == null) return null;

        final id = asset.id.split('/').first;
        final tempFile = File('$tempPath/feed_${id}_${DateTime.now().millisecondsSinceEpoch}.png');

        try {
          await file.copy(tempFile.path);
          return XFile(tempFile.path, mimeType: 'image/png');
        } catch (e) {
          // 파일 복사 에러 $e
          return null;
        }
      }),
    );
  }
}