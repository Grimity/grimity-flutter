// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 등록된 앨범이 없을 때 안내 문구를 표시하는 위젯.
class AlbumEditEmptyState extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsContainer(
      width: .infinity,
      padding: .symmetric(vertical: 32),
      child: Column(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          // 제목 표시
          GdsText(
            '아직 생성된 앨범이 없어요',
            color: .textGrayBold,
            style: .subtitle2,
          ),

          // 설명 표시
          GdsText(
            '앨범을 추가하면 그림을 분류할 수 있어요',
            color: .textGraySubtle,
            style: .label4,
          ),
        ],
      ),
    );
  }
}
