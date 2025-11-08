import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/data/model/post/post_detail_response.dart';
import 'package:grimity/data/model/post/post_response.dart';
import 'package:grimity/data/model/post/posts_response.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@injectable
@RestApi()
abstract class PostAPI {
  @factoryMethod
  factory PostAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _PostAPI;

  @POST('/posts')
  Future<IdResponse> createPost(@Body() CreatePostRequest request);

  @GET('/posts')
  Future<PostsResponse> getPosts(@Query('page') int page, @Query('size') int size, @Query('type') PostType type);

  @GET('/posts/notices')
  Future<List<PostResponse>> getNotices();

  @PUT('/posts/{id}')
  Future<void> updatePost(@Path('id') String id, @Body() CreatePostRequest request);

  @GET('/posts/search')
  Future<PostsResponse> searchPosts(
    @Query('page') int page,
    @Query('size') int size,
    @Query('keyword') String keyword,
    @Query('searchBy') SearchType searchBy,
  );

  @GET('/posts/{id}')
  Future<PostDetailResponse> getPostDetail(@Path('id') String id);

  @DELETE('/posts/{id}')
  Future<void> deletePost(@Path('id') String id);

  @PUT('/posts/{id}/like')
  Future<void> likePost(@Path('id') String id);

  @DELETE('/posts/{id}/like')
  Future<void> unlikePost(@Path('id') String id);

  @PUT('/posts/{id}/save')
  Future<void> savePost(@Path('id') String id);

  @DELETE('/posts/{id}/save')
  Future<void> removeSavedPost(@Path('id') String id);
}
