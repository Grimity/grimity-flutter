// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 앨범 이름을 수정하는 모달을 엽니다.
Future<String?> showAlbumRenameModal(
  BuildContext context, {
  required String albumName,
}) {
  return GdsAdaptiveModal.show(
    context,
    builder: (context) {
      final newAlbumName = context.stateOf(() => albumName);

      return .new(
        title: '앨범명 변경',
        secondaryButton: .new(
          label: '닫기',
          onTap: context.pop,
        ),
        primaryButton: .new(
          label: '변경하기',
          onTap: () => context.pop(newAlbumName.value),
          enabled: newAlbumName.trimmed.isNotEmpty && albumName != newAlbumName.trimmed,
        ),
        children: [
          GdsTextField.normal(
            size: .md,
            initialText: albumName,
            placeholder: '앨범 이름',
            onChanged: newAlbumName.setter,
          ),
        ],
      );
    },
  );
}
