// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 앨범 삭제 여부를 확인하는 알림창을 엽니다.
Future<bool?> showAlbumDeleteAlert(BuildContext context) {
  return GdsAlert.show(
    context,
    builder: (context) {
      return GdsAlert(
        title: '앨범을 삭제할까요?',
        description: '앨범을 삭제하면\n그림은 전체 항목으로 이동돼요',
        primaryButton: .new(
          label: '삭제하기',
          onTap: () => context.pop(true),
        ),
        secondaryButton: .new(
          label: '아니요',
          onTap: () => context.pop(false),
        ),
      );
    },
  );
}
