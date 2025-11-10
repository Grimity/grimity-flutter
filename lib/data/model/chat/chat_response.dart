import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/chat/chat_last_message_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'chat_response.freezed.dart';
part 'chat_response.g.dart';

@freezed
abstract class ChatResponse with _$ChatResponse {
  const factory ChatResponse({
    required String id,
    required int unreadCount,
    required DateTime enteredAt,
    required User opponentUser,
    required ChatLastMessageResponse? lastMessage,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, dynamic> json) => _$ChatResponseFromJson(json);
}
