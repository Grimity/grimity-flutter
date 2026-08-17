import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/gen/models/reply_to_response.dart';
import 'package:grimity/data/gen/models/user_base_response.dart';

part 'chat_message_socket_response.freezed.dart';
part 'chat_message_socket_response.g.dart';

@freezed
abstract class ChatMessageSocketResponse with _$ChatMessageSocketResponse {
  const factory ChatMessageSocketResponse({
    required String chatId,
    required String senderId,
    required List<UserBaseResponse> chatUsers,
    required List<ChatMessageSocketItem> messages,
  }) = _ChatMessageSocketResponse;

  factory ChatMessageSocketResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageSocketResponseFromJson(json);
}

@freezed
abstract class ChatMessageSocketItem with _$ChatMessageSocketItem {
  const factory ChatMessageSocketItem({
    required String id,
    required String? content,
    required String? image,
    required DateTime createdAt,
    required ReplyToResponse? replyTo,
  }) = _ChatMessageSocketItem;

  factory ChatMessageSocketItem.fromJson(Map<String, dynamic> json) => _$ChatMessageSocketItemFromJson(json);
}
