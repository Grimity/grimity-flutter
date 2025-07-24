import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/feed_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';

abstract class FeedCommentsRepository {
  Future<Result<void>> createFeedComment(CreateFeedCommentRequest request);

  Future<Result<List<Comment>>> getFeedComments(String feedId);

  Future<Result<void>> deleteFeedComment(String id);

  Future<Result<void>> likeFeedComment(String id);

  Future<Result<void>> unlikeFeedComment(String id);
}
