import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/data/model/post/post_detail_response.dart';
import 'package:grimity/data/model/post/posts_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@injectable
@RestApi()
abstract class PostAPI {
  @factoryMethod
  factory PostAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _PostAPI;

  @GET('/posts')
  Future<PostsResponse> getPosts(@Query('page') int page, @Query('size') int size, @Query('type') PostType type);

  @GET('/posts/{id}')
  Future<PostDetailResponse> getPostDetail(@Path('id') String id);

  @PUT('/posts/{id}/save')
  Future<void> savePost(@Path('id') String id);

  @DELETE('/posts/{id}/save')
  Future<void> removeSavedPost(@Path('id') String id);
}
