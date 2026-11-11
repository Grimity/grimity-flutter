// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 앨범 이름을 수정하는 모달을 엽니다.
Future<String?> showAlbumRenameModal(
  BuildContext context, {
  required String initialName,
}) {
  return GdsAdaptiveModal.show(
    context,
    builder: (context) {
      final newName = context.stateOf(() => initialName);
      final enabled = newName.trimmed.isNotEmpty && initialName != newName.trimmed;

      return .new(
        title: '앨범명 변경',
        primaryButton: .new(
          label: '변경하기',
          onTap: () => context.pop(newName.value),
          enabled: enabled,
        ),
        secondaryButton: .new(
          label: '닫기',
          onTap: context.pop,
        ),
        children: [
          GdsTextField.normal(
            size: .md,
            placeholder: '예시 : ‘크로키’ 또는 ‘일러스트’',
            initialText: initialName,
            onChanged: newName.setter,
          ),
        ],
      );
    },
  );
}
