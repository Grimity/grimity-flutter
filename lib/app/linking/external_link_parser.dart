import 'package:grimity/app/config/app_config.dart';

import 'external_link.dart';

class ExternalLinkParser {
  /// 서버에서 내려온 URL을 내부 라우팅 정보로 변환한다.
  /// 지원 형태:
  ///  - baseURL/:url
  ///  - baseURL/posts/postId
  ///  - baseURL/feeds/feedId
  static ExternalLink parse(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAbsolutePath) {
      return ExternalLink(ExternalLinkType.unknown);
    }

    final baseHost = Uri.tryParse(AppConfig.baseUrl)?.host;
    // host가 다르면 unknown 처리 (필요시 허용 목록 확장)
    if (uri.host != baseHost) {
      return ExternalLink(ExternalLinkType.unknown);
    }

    final segs = uri.pathSegments.where((e) => e.isNotEmpty).toList();
    if (segs.isEmpty) return ExternalLink(ExternalLinkType.unknown);

    // /posts/:id
    if (segs.length == 2 && segs.first == 'posts') {
      return ExternalLink(ExternalLinkType.post, id: segs[1]);
    }
    // /feeds/:id
    if (segs.length == 2 && segs.first == 'feeds') {
      return ExternalLink(ExternalLinkType.feed, id: segs[1]);
    }
    // /:userPath  (예약어 충돌 방지)
    if (segs.length == 1) {
      final url = segs.first;
      const reserved = {'posts', 'feeds'};
      if (!reserved.contains(url)) {
        return ExternalLink(ExternalLinkType.profile, url: url);
      }
    }

    return ExternalLink(ExternalLinkType.unknown);
  }
}
