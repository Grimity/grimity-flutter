import 'dart:io';
import 'package:gal/gal.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/app/network/provider/dio_provider.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_save_provider.g.dart';

@Riverpod(keepAlive: true)
class ImageSave extends _$ImageSave {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> saveByUrl(String imageUrl) async {
    if (state.isLoading) return;

    state = AsyncLoading();
    String? tempPath;

    try {
      // 권한 요청
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          throw Exception('갤러리 저장 권한이 필요합니다.');
        }
      }

      // 임시 파일 경로
      final ext = _extractExtensionFromUrl(imageUrl);
      final fileName = 'grimity_${DateTime.now().epochMillis}.$ext';
      tempPath = '${Directory.systemTemp.path}/$fileName';

      // 이미지 다운로드
      await kDio.download(imageUrl, tempPath);

      // 이미지 갤러리 저장
      await Gal.putImage(tempPath, album: 'Grimity');

      state = AsyncData(null);
      ToastService.showSuccess('이미지 저장이 완료되었어요.');
    } catch (e, st) {
      state = AsyncError(e, st);
      ToastService.showFailure('이미지 저장에 실패했습니다.');
    } finally {
      // 임시 파일 삭제
      if (tempPath != null) {
        final f = File(tempPath);
        if (await f.exists()) {
          await f.delete();
        }
      }
    }
  }

  // 확장자 추출
  String _extractExtensionFromUrl(String imageUrl) {
    try {
      final uri = Uri.parse(imageUrl);
      final path = uri.path.toLowerCase();

      if (path.endsWith('.webp')) return 'webp';
      if (path.endsWith('.png')) return 'png';
      if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'jpg';

      return 'webp';
    } catch (_) {
      return 'webp';
    }
  }
}
