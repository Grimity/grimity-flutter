// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/chat/models/chat_message_payload.dart';
import 'package:pervice_openapi/pervice_openapi.dart';

/// 새 채팅 메시지 소켓 이벤트의 데이터.
class NewChatMessagePayload({
  required final String chatId,
  required final String senderId,
  required final List<UserBaseResponse> chatUsers,
  required final List<ChatMessagePayload> messages,
}) {
  /// 소켓 메시지 목록을 채팅 메시지 응답 모델로 변환합니다.
  List<ChatMessageResponse> toResponse() {
    final sender = chatUsers.firstWhere((user) => user.id == senderId);

    return messages.builder((message) {
      return .new(
        id: message.id,
        content: message.content,
        image: message.image,
        images: message.images,
        createdAt: message.createdAt,
        user: sender,
        isLike: false,
        type: .user,
        replyTo: message.replyTo,
      );
    });
  }

  /// 소켓 이벤트 데이터를 [NewChatMessagePayload]로 변환합니다.
  static NewChatMessagePayload decode(Map<String, dynamic> obj) {
    final messages = (obj['messages'] as List).cast<Map<String, dynamic>>();

    return .new(
      chatId: obj.decode<String>('chatId')!,
      senderId: obj.decode<String>('senderId')!,
      chatUsers: obj.decode<List<UserBaseResponse>>('chatUsers')!,
      messages: messages.builder(ChatMessagePayload.decode),
    );
  }
}
