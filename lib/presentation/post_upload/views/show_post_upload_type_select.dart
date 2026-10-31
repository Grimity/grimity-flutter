// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_type.dart';
import 'package:grimity/presentation/post_upload/pages/post_upload_page.dart';

/// 업로드 시 게시글 유형을 선택하는 팝업을 표시합니다.
Future<PostType?> showPostUploadTypeSelect(
  BuildContext context,
  PostType selectedType,
) {
  return GdsAdaptiveModal.show<PostType>(
    context,
    builder: (context) => GdsAdaptiveModal(
      title: '말머리 선택',
      children: PostUploadPage.postTypes.builder((type) {
        final isSelected = selectedType == type;

        return GdsListItem.optionCard(
          status: .from(selected: isSelected),
          label: type.displayName,
          onTap: () => context.pop(type),
        );
      }),
    ),
  );
}
