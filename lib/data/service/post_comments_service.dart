import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/create_post_comment_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_comment_mapper.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PostCommentsService {
  final RestClient _client;

  PostCommentsService(this._client);

  Future<Result<void>> createPostComment(CreatePostCommentRequest request) async {
    try {
      await _client.postComments.postCommentCreatePostComment(
        body: generated.CreatePostCommentRequest.fromJson(request.toJson()),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<Comment>>> getPostComments(String postId) async {
    try {
      final response = await _client.postComments.postCommentGetPostComments(postId: postId);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deletePostComment(String id) async {
    try {
      await _client.postComments.postCommentDeletePostComment(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> likePostComment(String id) async {
    try {
      await _client.postComments.postCommentLikePostComment(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> unlikePostComment(String id) async {
    try {
      await _client.postComments.postCommentUnlikePostComment(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
