// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/chat_messages_response.dart';
import '../models/create_chat_message_request.dart';

part 'chat_messages_api.g.dart';

@RestApi()
abstract class ChatMessagesApi {
  factory ChatMessagesApi(Dio dio, {String? baseUrl}) = _ChatMessagesApi;

  /// 채팅 보내기
  @POST('/chat-messages')
  Future<void> chatMessageCreate({
    @Body() required CreateChatMessageRequest body,
  });

  /// 채팅방 메세지 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  ///
  /// [chatId] - 채팅방 ID.
  @GET('/chat-messages')
  Future<ChatMessagesResponse> chatMessageGetMessages({
    @Query('chatId') required String chatId,
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 채팅 좋아요
  @PUT('/chat-messages/{id}/like')
  Future<void> chatMessageLikeMessage({
    @Path('id') required String id,
  });

  /// 채팅 좋아요 취소
  @DELETE('/chat-messages/{id}/like')
  Future<void> chatMessageUnlikeMessage({
    @Path('id') required String id,
  });
}
