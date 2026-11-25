// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_link.dart';
import 'package:grimity/presentation/chat/pages/chat_page.dart';

/// 채팅방 링크를 처리하고 해당 대화 페이지를 엽니다.
final class ChatLink extends AppLink {
  const new();

  @override
  void onLink(BuildContext context, Uri uri) {
    final segments = uri.pathSegments;

    // chats/:id
    if (segments.length != 2) return;
    if (segments.first != 'chats') return;
    if (segments.last.isEmpty) return;

    // 알림에 포함된 채팅방 열기.
    context.push(ChatPage(id: segments.last));
  }
}
