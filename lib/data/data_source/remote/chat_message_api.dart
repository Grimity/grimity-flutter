import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/chat_message/chat_message_response.dart';
import 'package:grimity/domain/dto/chat_message_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_message_api.g.dart';

@injectable
@RestApi()
abstract class ChatMessageAPI {
  @factoryMethod
  factory ChatMessageAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _ChatMessageAPI;

  @POST("/chat-messages")
  Future<void> sendMessage(@Body() SendChatMessageRequest request);

  @GET("/chat-messages")
  Future<ChatMessageResponse> getMessages(
    @Query('size') int? size,
    @Query('cursor') String? cursor,
    @Query('chatId') String chatId,
  );

  @PUT("/chat-messages/{id}/like")
  Future<void> likeMessage(@Path('id') String id);

  @DELETE("/chat-messages/{id}/like")
  Future<void> unlikeMessage(@Path('id') String id);
}
