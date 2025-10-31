import 'package:flutter/services.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareUtil {
  /// 링크 복사하기
  static Future<void> copyLinkToClipboard(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    ToastService.show('링크가 복사되었어요.');
  }

  /// 트위터(X)로 공유하기
  static Future<void> shareToTwitter({required String text, required String url}) async {
    final encodedText = Uri.encodeComponent(text);
    final encodedUrl = Uri.encodeComponent(url);
    final shareUrl = 'https://x.com/intent/post?text=$encodedText&url=$encodedUrl';

    try {
      await launchUrl(Uri.parse(shareUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      ToastService.show('X 공유에 실패했습니다.');
    }
  }
}
