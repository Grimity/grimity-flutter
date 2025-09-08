import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';

abstract class PostRepository {
  Future<Result<String>> createPost(CreatePostRequest request);

  Future<Result<Posts>> getPosts(int page, int size, PostType type);

  Future<Result<void>> updatePost(String id, CreatePostRequest request);

  Future<Result<Posts>> searchPosts(int page, int size, String keyword, SearchType searchBy);

  Future<Result<Post>> getPostDetail(String id);

  Future<Result<void>> deletePost(String id);

  Future<Result<void>> likePost(String id);

  Future<Result<void>> unlikePost(String id);

  Future<Result<void>> savePost(String id);

  Future<Result<void>> removeSavedPost(String id);
  Future<Result<List<Post>>> searchPosts({
    required int page,
    required int size,
    required String keyword,
    required SearchBy searchBy,
  });
}
