import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';

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

  static Image getLinkImage(String linkName, double width, double height) {
    if (linkName == LinkType.x.linkName) {
      return Assets.icons.profile.x.image(width: width, height: height);
    } else if (linkName == LinkType.instagram.linkName) {
      return Assets.icons.profile.instagram.image(width: width, height: height);
    } else if (linkName == LinkType.youtube.linkName) {
      return Assets.icons.profile.youtube.image(width: width, height: height);
    } else if (linkName == LinkType.pixiv.linkName) {
      return Assets.icons.profile.pixiv.image(width: width, height: height);
    } else if (linkName == LinkType.email.linkName) {
      return Assets.icons.profile.mail.image(width: width, height: height);
    } else {
      return Assets.icons.profile.web.image(width: width, height: height);
    }
  }

  static bool isCustomLinkType(String linkName) {
    if (linkName == LinkType.x.linkName ||
        linkName == LinkType.instagram.linkName ||
        linkName == LinkType.youtube.linkName ||
        linkName == LinkType.pixiv.linkName ||
        linkName == LinkType.email.linkName) {
      return false;
    }

    return true;
  }
}
