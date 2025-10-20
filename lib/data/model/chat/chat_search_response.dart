import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/chat/chat_response.dart';

part 'chat_search_response.freezed.dart';
part 'chat_search_response.g.dart';

@freezed
abstract class ChatSearchResponse with _$ChatSearchResponse {
  const factory ChatSearchResponse({
    String? nextCursor,
    required List<ChatResponse> chats,
  }) = _ChatSearchResponse;

  factory ChatSearchResponse.fromJson(Map<String, dynamic> json) => _$ChatSearchResponseFromJson(json);
}