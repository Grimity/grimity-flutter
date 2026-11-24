// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/api/api.dart';
import 'package:pervice_openapi/pervice_openapi.dart';

/// 새 채팅 메시지 소켓 이벤트에 포함된 메시지 데이터.
class ChatMessagePayload({
  required final String id,
  required final String? content,
  required final String? image,
  required final List<String> images,
  required final DateTime createdAt,
  required final ReplyToResponse? replyTo,
}) {
  /// 소켓 메시지 데이터를 모델로 변환합니다.
  static ChatMessagePayload decode(Map<String, dynamic> obj) {
    return .new(
      id: obj.decode<String>('id')!,
      content: obj.decode<String>('content'),
      image: obj.decode<String>('image'),
      images: obj.decode<List<String>>('images')!,
      createdAt: obj.decode<DateTime>('createdAt')!,
      replyTo: obj.decode<ReplyToResponse>('replyTo'),
    );
  }
}
