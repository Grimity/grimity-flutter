// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/api/api.dart';

/// [NotificationResponse]에 대한 유틸리티 확장.
extension NotificationResponseExtension on NotificationResponse {
  /// 알림 메시지에서 추론한 알림 유형.
  String get type {
    if (message.contains('팔로우')) return '팔로우';
    if (message.contains('좋아요')) return '좋아요';
    if (message.contains('대댓글')) return '새 대댓글';
    if (message.contains('댓글')) return '새 댓글';
    return '알림';
  }
}
