// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:material_ui/material_ui.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/storage/pages/storage_page.dart';

/// 보관함 페이지의 목록을 전환하는 탭바.
class StorageTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.whenDevice(
        mobile: 16.horizontal,
        tablet: 20.horizontal,
      ),
      child: GdsTabBar(
        controller: controller,
        items: StoragePage.views.items,
      ),
    );
  }
}
