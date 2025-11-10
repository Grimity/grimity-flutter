import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/chat_message/chat_message_reply_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';

part 'chat_message_item_response.freezed.dart';
part 'chat_message_item_response.g.dart';

@freezed
abstract class ChatMessageItemResponse with _$ChatMessageItemResponse {
  const factory ChatMessageItemResponse({
    required String id,
    required String? content,
    required String? image,
    required DateTime createdAt,
    required UserBaseResponse user,
    required bool isLike,
    required ChatMessageReplyResponse? replyTo,
  }) = _ChatMessageItemResponse;

  factory ChatMessageItemResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageItemResponseFromJson(json);
}
