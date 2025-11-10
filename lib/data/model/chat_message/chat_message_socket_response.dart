import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/data/model/chat_message/chat_message_item_socket_response.dart';

part 'chat_message_socket_response.freezed.dart';
part 'chat_message_socket_response.g.dart';

@freezed
abstract class ChatMessageSocketResponse with _$ChatMessageSocketResponse {
  const factory ChatMessageSocketResponse({
    required String chatId,
    required String senderId,
    required List<UserBaseResponse> chatUsers,
    required List<ChatMessageItemSocketResponse> messages,
  }) = _ChatMessageSocketResponse;

  factory ChatMessageSocketResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageSocketResponseFromJson(json);
}
