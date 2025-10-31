import 'package:flutter/services.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
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

  /// 카카오톡으로 공유하기
  static Future<void> shareToKakao({
    required String description,
    required String? imageUrl,
    required String linkUrl,
  }) async {
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    // FeedTemplate 사용
    final template = FeedTemplate(
      content: Content(
        title: '그림 커뮤니티 그리미티',
        description: description,
        // TODO 이미지가 없는 경우에 기본값
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
        link: Link(webUrl: Uri.parse(linkUrl), mobileWebUrl: Uri.parse(linkUrl)),
      ),
      buttons: [Button(title: '자세히 보기', link: Link(webUrl: Uri.parse(linkUrl), mobileWebUrl: Uri.parse(linkUrl)))],
    );

    if (isKakaoTalkSharingAvailable) {
      Uri uri = await ShareClient.instance.shareDefault(template: template);
      await ShareClient.instance.launchKakaoTalk(uri);
    } else {
      Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: template);
      await launchBrowserTab(shareUrl, popupOpen: true);
    }
  }
}
