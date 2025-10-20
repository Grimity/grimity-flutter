import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_reply_response.freezed.dart';
part 'chat_message_reply_response.g.dart';

@freezed
abstract class ChatMessageReplyResponse with _$ChatMessageReplyResponse {
  const factory ChatMessageReplyResponse({
    required String id,
    required String? content,
    required String? image,
    required DateTime createdAt,
  }) = _ChatMessageReplyResponse;

  factory ChatMessageReplyResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageReplyResponseFromJson(json);
}