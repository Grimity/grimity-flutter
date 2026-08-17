import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/create_feed_comment_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_comment_mapper.dart';
import 'package:grimity/domain/dto/feed_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FeedCommentsService {
  final RestClient _client;

  FeedCommentsService(this._client);

  Future<Result<void>> createFeedComment(CreateFeedCommentRequest request) async {
    try {
      await _client.feedComments.feedCommentCreate(
        body: generated.CreateFeedCommentRequest.fromJson(request.toJson()),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<Comment>>> getFeedComments(String feedId) async {
    try {
      final response = await _client.feedComments.feedCommentFindAll(feedId: feedId);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteFeedComment(String id) async {
    try {
      await _client.feedComments.feedCommentDeleteOne(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> likeFeedComment(String id) async {
    try {
      await _client.feedComments.feedCommentLike(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> unlikeFeedComment(String id) async {
    try {
      await _client.feedComments.feedCommentUnlike(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
