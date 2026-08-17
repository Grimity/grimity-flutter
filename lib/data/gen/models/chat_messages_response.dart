// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message_response.dart';

part 'chat_messages_response.freezed.dart';
part 'chat_messages_response.g.dart';

@Freezed()
abstract class ChatMessagesResponse with _$ChatMessagesResponse {
  const factory ChatMessagesResponse({
    required String? nextCursor,
    required List<ChatMessageResponse> messages,
  }) = _ChatMessagesResponse;

  factory ChatMessagesResponse.fromJson(Map<String, Object?> json) => _$ChatMessagesResponseFromJson(json);
}
