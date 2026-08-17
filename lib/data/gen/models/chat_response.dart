// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'last_chat_message_response.dart';
import 'user_base_response.dart';

part 'chat_response.freezed.dart';
part 'chat_response.g.dart';

@Freezed()
abstract class ChatResponse with _$ChatResponse {
  const factory ChatResponse({
    required String id,
    required num unreadCount,
    required DateTime enteredAt,

    /// 채팅 상대의 사용자 정보
    required UserBaseResponse opponentUser,

    /// 채팅방의 마지막 메시지
    required LastChatMessageResponse? lastMessage,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, Object?> json) => _$ChatResponseFromJson(json);
}
