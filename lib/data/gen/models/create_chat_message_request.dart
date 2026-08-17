// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_message_request.freezed.dart';
part 'create_chat_message_request.g.dart';

@Freezed()
abstract class CreateChatMessageRequest with _$CreateChatMessageRequest {
  const factory CreateChatMessageRequest({
    required String chatId,
    required List<String> images,

    /// 본문내용
    String? content,

    /// 답장 채팅메시지 ID
    String? replyToId,
  }) = _CreateChatMessageRequest;

  factory CreateChatMessageRequest.fromJson(Map<String, Object?> json) => _$CreateChatMessageRequestFromJson(json);
}
