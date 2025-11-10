import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/chat_message/chat_message_item_response.dart';

part 'chat_message_response.freezed.dart';
part 'chat_message_response.g.dart';

@freezed
abstract class ChatMessageResponse with _$ChatMessageResponse {
  const factory ChatMessageResponse({required String? nextCursor, required List<ChatMessageItemResponse> messages}) =
      _ChatMessageResponse;

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageResponseFromJson(json);
}
