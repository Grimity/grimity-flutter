// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_links.dart';

/// 프로필에 등록된 외부 링크의 수정 항목을 선택하는 팝업을 엽니다.
Future<LinkResponse?> showProfileLinkEditSelect(
  BuildContext context,
  LayerLink layerLink, {
  required LinkResponse link,
}) {
  const items = [
    ...ProfileEditLinks.linkTypes,
    '', // 직접 입력
  ];

  return GdsAdaptiveSelect.show(
    context,
    layerLink: layerLink,
    position: .left,
    builder: (context) {
      final index = items.indexOf(link.linkName);

      return .new(
        title: '외부 링크 선택',
        index: index == -1 ? items.length - 1 : index,
        items: items.builder((item) {
          return (
            label: item.isEmpty ? '직접 입력' : item,
            onTap: () => context.pop(
              LinkResponse(linkName: item, link: link.link),
            ),
          );
        }),
      );
    },
  );
}
