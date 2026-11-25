// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_link.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';

/// 글 상세 페이지에 대한 링크를 처리하고 해당 페이지를 엽니다.
final class PostDetailLink extends AppLink {
  const new();

  @override
  void onLink(BuildContext context, Uri uri) {
    final segments = uri.pathSegments;

    // posts/:id
    if (segments.length != 2) return;
    if (segments.first != 'posts') return;
    if (segments.last.isEmpty) return;

    // 링크에 포함된 아이디로 상세 페이지 열기.
    context.push(PostDetailPage(id: segments.last));
  }
}
