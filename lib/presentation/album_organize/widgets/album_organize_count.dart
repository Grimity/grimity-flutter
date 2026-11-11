// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 앨범에 담긴 총 피드의 개수를 표시하는 위젯.
class AlbumOrganizeCount extends StatelessWidget {
  const new({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        spacing: 2,
        children: [
          GdsText(
            '그림',
            color: .textGrayNormal,
            style: .label4,
          ),

          GdsText(
            count.toString(),
            color: .textGrayBold,
            style: .label4,
          ),
        ],
      ),
    );
  }
}
