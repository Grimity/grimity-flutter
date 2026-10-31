// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 생성된 앨범이 없어 전체 앨범에 업로드됨을 안내하는 팝업을 표시합니다.
Future<void> showFeedUploadNoAlbumAlert(BuildContext context) async {
  return GdsAlert.show<void>(
    context,
    builder: (context) => GdsAlert(
      title: '아직 생성된 앨범이 없어요',
      description: '전체 앨범에 업로드 되며\n 새 앨범은 프로필 화면에서 추가할 수 있어요',
      primaryButton: .new(
        label: '확인',
        onTap: context.pop,
      ),
    ),
  );
}
