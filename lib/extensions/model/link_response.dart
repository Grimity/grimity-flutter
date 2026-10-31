// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/string_extension.dart';

/// [LinkResponse]에 대한 유틸리티 확장.
extension LinkResponseExtension on LinkResponse {
  /// 현재 로그인한 사용자의 프로필인지 여부.
  GdsIcon get icon {
    if (link.contains('instagram.com')) return .logoInstagramBg;
    if (link.contains('x.com')) return .logoXBg;
    if (link.contains('pixiv.net')) return .logoPixivBg;
    if (link.contains('youtube.com')) return .logoYoutubeBg;
    if (link.isEmail) return .logoEmail;

    return .link;
  }

  /// 이메일 주소에는 mailto 스킴을 적용하고, 일반 링크는 URI로 변환합니다.
  Uri get uri {
    return link.isEmail ? Uri(scheme: 'mailto', path: link) : Uri.parse(link);
  }
}
