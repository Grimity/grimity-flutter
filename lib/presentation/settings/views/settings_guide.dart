// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';

/// 이용 안내 게시글을 표시하는 설정 페이지.
class SettingsGuide extends StatelessWidget with GdsListDetailPage {
  const new({super.key});

  @override
  GdsIcon get icon => .infoCircle;

  @override
  String get title => '이용 안내';

  @override
  bool get pushDirectly => true;

  @override
  Widget build(BuildContext context) {
    return const PostDetailPage.guide();
  }
}
