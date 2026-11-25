// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/chat/links/chat_link.dart';
import 'package:grimity/presentation/feed_detail/links/feed_detail_link.dart';
import 'package:grimity/presentation/post_detail/links/post_detail_link.dart';
import 'package:grimity/presentation/profile/links/profile_link.dart';

/// 앱에서 수신한 링크의 처리 방식을 정의합니다.
abstract class AppLink {
  const new();

  /// 앱에서 처리할 링크 목록.
  static const links = <AppLink>[
    FeedDetailLink(),
    PostDetailLink(),
    ChatLink(),
    ProfileLink(),
  ];

  /// 딥링크 수신을 초기화하고 링크에 따른 화면 이동을 처리합니다.
  static void initialize() {
    AppLinks().uriLinkStream.listen(handle);
  }

  /// 수신한 URI를 등록된 링크 처리기에 전달합니다.
  static void handle(Uri uri) {
    if (uri.host != 'www.grimity.com') {
      return;
    }

    // 앱 이용에 로그인이 필수적이므로 로그인되지 않은 경우 링크 무시.
    if (AppUser.status != .loaded) {
      return;
    }

    final context = GdsApp.navigationKey.currentContext;
    if (context == null || !context.mounted) return;

    // 등록된 처리기로 수신한 링크 처리.
    for (final link in links) {
      link.onLink(context, uri);
    }
  }

  /// 수신한 링크에 따른 동작을 처리합니다.
  void onLink(BuildContext context, Uri uri);
}
