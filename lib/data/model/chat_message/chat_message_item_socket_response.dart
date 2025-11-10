import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/chat_message/chat_message_reply_response.dart';

part 'chat_message_item_socket_response.freezed.dart';
part 'chat_message_item_socket_response.g.dart';

@freezed
abstract class ChatMessageItemSocketResponse with _$ChatMessageItemSocketResponse {
  const factory ChatMessageItemSocketResponse({
    required String id,
    required String? content,
    required String? image,
    required DateTime createdAt,
    required ChatMessageReplyResponse? replyTo,
  }) = _ChatMessageItemSocketResponse;

  factory ChatMessageItemSocketResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageItemSocketResponseFromJson(json);
}
