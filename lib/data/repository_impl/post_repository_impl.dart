import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/data/data_source/remote/post_api.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/data/model/post/post_detail_response.dart';
import 'package:grimity/data/model/post/posts_response.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PostRepository)
class PostRepositoryImpl extends PostRepository {
  final PostAPI _postAPI;

  PostRepositoryImpl(this._postAPI);

  @override
  Future<Result<String>> createPost(CreatePostRequest request) async {
    try {
      final IdResponse response = await _postAPI.createPost(request);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Posts>> getPosts(int page, int size, PostType type) async {
    try {
      final PostsResponse response = await _postAPI.getPosts(page, size, type);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> updatePost(String id, CreatePostRequest request) async {
    try {
      await _postAPI.updatePost(id, request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Posts>> searchPosts(int page, int size, String keyword, SearchType searchBy) async {
    try {
      final PostsResponse response = await _postAPI.searchPosts(page, size, keyword, searchBy);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Post>> getPostDetail(String id) async {
    try {
      final PostDetailResponse response = await _postAPI.getPostDetail(id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deletePost(String id) async {
    try {
      await _postAPI.deletePost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> likePost(String id) async {
    try {
      await _postAPI.likePost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> unlikePost(String id) async {
    try {
      await _postAPI.unlikePost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> savePost(String id) async {
    try {
      await _postAPI.savePost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> removeSavedPost(String id) async {
    try {
      await _postAPI.removeSavedPost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
