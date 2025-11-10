import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/chat/chat_search_response.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/dto/chat_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_api.g.dart';

@injectable
@RestApi()
abstract class ChatAPI {
  @factoryMethod
  factory ChatAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _ChatAPI;

  @POST("/chats")
  Future<IdResponse> createChat(@Body() CreateChatRequest request);

  @DELETE("/chats/{id}")
  Future<void> deleteChat(@Path('id') String id);

  @GET('/chats')
  Future<ChatSearchResponse> search(
    @Query('size') int? size,
    @Query('cursor') String? cursor,
    @Query('keyword') String? keyword,
  );

  @POST("/chats/batch-delete")
  Future<void> batchDeleteChat(@Body() BatchDeleteChatRequest request);

  @GET("/chats/{id}/user")
  Future<UserBaseResponse> getUserByChat(@Path('id') String id);

  @PUT("/chats/{id}/join")
  Future<void> join(@Path('id') String id, @Body() SocketChatRequest request);

  @PUT("/chats/{id}/leave")
  Future<void> leave(@Path('id') String id, @Body() SocketChatRequest request);
}
