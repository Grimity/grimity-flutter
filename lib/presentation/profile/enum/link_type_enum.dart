import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/link.dart';

enum LinkType {
  x('X', 'https://x.com/'),
  instagram('인스타그램', 'https://www.instagram.com/'),
  youtube('유튜브', 'https://www.youtube.com/'),
  pixiv('픽시브', 'https://www.pixiv.net/'),
  email('이메일', ''),
  custom('직접 입력', 'https://');

  final String linkName;
  final String defaultLink;

  const LinkType(this.linkName, this.defaultLink);

  static final Map<String, LinkType> _byLinkName = {
    for (var type in values) type.linkName: type,
  };

  static LinkType from(Link link) {
    return _byLinkName[link.linkName] ?? LinkType.custom;
  }

  GdsIcon get icon => switch (this) {
    LinkType.x => GdsIcon.xBg,
    LinkType.instagram => GdsIcon.instagramBg,
    LinkType.youtube => GdsIcon.youtubeBg,
    LinkType.pixiv => GdsIcon.pixivBg,
    LinkType.email => GdsIcon.email,
    LinkType.custom => GdsIcon.link,
  };

  bool get isCustom => this == LinkType.custom;
}

typedef LinkParser = String? Function(String);

class LinkParsers {
  static final Map<LinkType, LinkParser> _map = {
    LinkType.x: _extractTwitter,
    LinkType.instagram: _extractInstagram,
    LinkType.youtube: _extractYoutube,
    LinkType.email: _extractEmail,
  };

  /// 등록된 타입만 파싱, 나머지는 null 반환
  static String? parse(LinkType type, String raw) {
    final result = _map[type]?.call(raw);

    if (result == null) return result;

    // SNS 유형은 @ prefix 추가
    return (type == LinkType.x || type == LinkType.instagram || type == LinkType.youtube) ? '@$result' : result;
  }

  /// Twitter/X 사용자명 추출
  /// ex) https://x.com/username?s=20 → username
  static String? _extractTwitter(String text) {
    final regex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:twitter\.com|x\.com)\/([A-Za-z0-9_]+)',
      caseSensitive: false,
    );
    return regex.firstMatch(text)?.group(1);
  }

  /// Instagram 사용자명 추출
  /// ex) https://instagram.com/user.name?... → user.name
  static String? _extractInstagram(String text) {
    final regex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:instagram\.com)\/([A-Za-z0-9_.]+)',
      caseSensitive: false,
    );
    return regex.firstMatch(text)?.group(1);
  }

  /// YouTube 핸들(@username) 추출
  /// ex) https://youtube.com/@CreatorName → CreatorName
  static String? _extractYoutube(String text) {
    final regex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com)\/@([A-Za-z0-9_.-]+)',
      caseSensitive: false,
    );
    return regex.firstMatch(text)?.group(1);
  }

  /// 이메일 주소 추출
  /// ex) `email@domain.com` from mixed text
  static String? _extractEmail(String text) {
    final regex = RegExp(
      r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
      caseSensitive: false,
    );
    return regex.firstMatch(text)?.group(0);
  }
}
