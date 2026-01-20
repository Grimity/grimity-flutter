import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/linking/external_link.dart';
import 'package:grimity/app/linking/external_link_parser.dart';

abstract class UrlHandler {
  // URL을 내부 라우팅으로 이동
  static void handleServerUrl(BuildContext context, String url) {
    final parsed = ExternalLinkParser.parse(url);

    switch (parsed.type) {
      case ExternalLinkType.profile:
      case ExternalLinkType.post:
      case ExternalLinkType.feed:
        context.push(parsed.location);
        break;
      case ExternalLinkType.unknown:
        break;
    }
  }
}
