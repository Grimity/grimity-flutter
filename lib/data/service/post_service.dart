import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/data/gen/models/create_post_request.dart' as generated;
import 'package:grimity/data/gen/models/post_search_by.dart' as generated;
import 'package:grimity/data/gen/models/post_type.dart' as generated;
import 'package:grimity/data/gen/models/post_type_filter.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_post_mapper.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PostService {
  final RestClient _client;

  PostService(this._client);

  Future<Result<String>> createPost(CreatePostRequest request) async {
    try {
      final response = await _client.posts.postCreate(
        body: generated.CreatePostRequest(
          title: request.title,
          content: request.content,
          type: generated.PostType.fromJson(request.type.toJson()),
        ),
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Posts>> getPosts(int page, int size, PostType type) async {
    try {
      final response = await _client.posts.postGetPosts(
        page: page,
        size: size,
        type: generated.PostTypeFilter.fromJson(type.toJson()),
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<Post>>> getNotices() async {
    try {
      final response = await _client.posts.postGetNotices();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updatePost(String id, CreatePostRequest request) async {
    try {
      await _client.posts.postUpdate(
        id: id,
        body: generated.CreatePostRequest(
          title: request.title,
          content: request.content,
          type: generated.PostType.fromJson(request.type.toJson()),
        ),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Posts>> searchPosts(int page, int size, String keyword, SearchType searchBy) async {
    try {
      final response = await _client.posts.postSearchPosts(
        page: page,
        size: size,
        keyword: keyword,
        searchBy: generated.PostSearchBy.fromJson(searchBy.toJson()),
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Post>> getPostDetail(String id) async {
    try {
      final response = await _client.posts.postGetPost(id: id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deletePost(String id) async {
    try {
      await _client.posts.postDelete(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> likePost(String id) async {
    try {
      await _client.posts.postLike(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> unlikePost(String id) async {
    try {
      await _client.posts.postUnlike(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> savePost(String id) async {
    try {
      await _client.posts.postSave(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> removeSavedPost(String id) async {
    try {
      await _client.posts.postUnsave(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
