import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_last_message_response.freezed.dart';
part 'chat_last_message_response.g.dart';

@freezed
abstract class ChatLastMessageResponse with _$ChatLastMessageResponse {
  const factory ChatLastMessageResponse({
    required String id,
    required String? content,
    required String? image,
    required DateTime createdAt,
    required String? senderId,
  }) = _ChatLastMessageResponse;

  factory ChatLastMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatLastMessageResponseFromJson(json);
}
