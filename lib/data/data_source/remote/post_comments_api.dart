import 'package:dio/dio.dart';
import 'package:grimity/data/model/post_comments/parent_post_comment_response.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'post_comments_api.g.dart';

@injectable
@RestApi()
abstract class PostCommentsAPI {
  @factoryMethod
  factory PostCommentsAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _PostCommentsAPI;

  @POST('/post-comments')
  Future<void> createPostComment(@Body() CreatePostCommentRequest request);

  @GET('/post-comments')
  Future<List<ParentPostCommentResponse>> getPostComments(@Query('postId') String postId);

  @DELETE('/post-comments/{id}')
  Future<void> deletePostComment(@Path('id') String id);

  @PUT('/post-comments/{id}/like')
  Future<void> likePostComment(@Path('id') String id);

  @DELETE('/post-comments/{id}/like')
  Future<void> unlikePostComment(@Path('id') String id);
}
