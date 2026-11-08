// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/model/link_response.dart';
import 'package:url_launcher/url_launcher.dart';

/// 사용자 프로필에 등록된 외부 링크 목록을 표시하는 모달을 엽니다.
Future<void> showProfileLinksModal(
  BuildContext context,
  List<LinkResponse> links,
) {
  return GdsAdaptiveModal.show(
    context,
    builder: (context) {
      return .new(
        title: '프로필 링크',
        spacing: 0,
        children: links.builder((link) {
          return GdsUserItem.link(
            name: link.linkName,
            link: link.link,
            icon: link.icon,
            onTap: () => launchUrl(link.uri),
          );
        }),
      );
    },
  );
}
