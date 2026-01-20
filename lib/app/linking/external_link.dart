import 'package:grimity/app/config/app_router.dart';

enum ExternalLinkType {
  profile,
  post,
  feed,
  unknown,
}

class ExternalLink {
  const ExternalLink(
    this.type, {
    this.url,
    this.id,
  });

  final ExternalLinkType type;
  final String? url;
  final String? id;

  String get location => switch (type) {
    ExternalLinkType.profile => ProfileRoute.makePath(url!),
    ExternalLinkType.post => PostDetailRoute.makePath(id!),
    ExternalLinkType.feed => FeedDetailRoute.makePath(id!),
    ExternalLinkType.unknown => throw UnimplementedError('unknown은 location을 사용할 수 없습니다.'),
  };
}
