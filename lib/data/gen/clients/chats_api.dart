// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/batch_delete_chats_request.dart';
import '../models/chats_response.dart';
import '../models/create_chat_request.dart';
import '../models/id_response.dart';
import '../models/join_chat_request.dart';
import '../models/leave_chat_request.dart';
import '../models/opponent_user_response.dart';

part 'chats_api.g.dart';

@RestApi()
abstract class ChatsApi {
  factory ChatsApi(Dio dio, {String? baseUrl}) = _ChatsApi;

  /// 채팅방 생성
  @POST('/chats')
  Future<IdResponse> chatCreateChat({
    @Body() required CreateChatRequest body,
  });

  /// 채팅방 목록 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  ///
  /// [keyword] - 검색할 사용자 이름.
  @GET('/chats')
  Future<ChatsResponse> chatSearch({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
    @Query('keyword') String? keyword,
  });

  /// 채팅방 여러개 삭제
  @POST('/chats/batch-delete')
  Future<void> chatDeleteManyChat({
    @Body() required BatchDeleteChatsRequest body,
  });

  /// 채팅방 삭제
  @DELETE('/chats/{id}')
  Future<void> chatDeleteChat({
    @Path('id') required String id,
  });

  /// 상대 유저 조회
  @GET('/chats/{id}/user')
  Future<OpponentUserResponse> chatGetOpponentUser({
    @Path('id') required String id,
  });

  /// 채팅방 입장
  @PUT('/chats/{id}/join')
  Future<void> chatJoinChat({
    @Path('id') required String id,
    @Body() required JoinChatRequest body,
  });

  /// 채팅방 나가기
  @PUT('/chats/{id}/leave')
  Future<void> chatLeaveChat({
    @Path('id') required String id,
    @Body() required LeaveChatRequest body,
  });
}
