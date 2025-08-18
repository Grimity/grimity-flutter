import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';

abstract class PostCommentsRepository {
  Future<Result<void>> createPostComment(CreatePostCommentRequest request);

  Future<Result<List<Comment>>> getPostComments(String postId);

  Future<Result<void>> deletePostComment(String id);

  Future<Result<void>> likePostComment(String id);

  Future<Result<void>> unlikePostComment(String id);
}
