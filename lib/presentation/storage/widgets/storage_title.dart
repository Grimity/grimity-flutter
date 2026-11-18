// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 보관함 페이지의 제목을 표시하는 위젯.
class StorageTitle extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsContainer(
      alignment: .centerLeft,
      padding: context.whenDevice(
        mobile: 12.vertical + 16.horizontal,
        tablet: 24.vertical + 20.horizontal,
      ),
      child: GdsText(
        '내 보관함',
        color: .textGrayBold,
        style: context.whenDevice(
          mobile: .title2,
          tablet: .title1,
        ),
      ),
    );
  }
}
