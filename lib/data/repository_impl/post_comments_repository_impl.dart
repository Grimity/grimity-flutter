import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/post_comments_api.dart';
import 'package:grimity/data/model/post_comments/parent_post_comment_response.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/domain/repository/post_comments_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PostCommentsRepository)
class PostCommentsRepositoryImpl extends PostCommentsRepository {
  final PostCommentsAPI _postCommentsAPI;

  PostCommentsRepositoryImpl(this._postCommentsAPI);

  @override
  Future<Result<void>> createPostComment(CreatePostCommentRequest request) async {
    try {
      await _postCommentsAPI.createPostComment(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<List<Comment>>> getPostComments(String postId) async {
    try {
      final List<ParentPostCommentResponse> response = await _postCommentsAPI.getPostComments(postId);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deletePostComment(String id) async {
    try {
      await _postCommentsAPI.deletePostComment(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> likePostComment(String id) async {
    try {
      await _postCommentsAPI.likePostComment(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> unlikePostComment(String id) async {
    try {
      await _postCommentsAPI.unlikePostComment(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
