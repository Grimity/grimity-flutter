import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/feed_comments_api.dart';
import 'package:grimity/data/model/feed_comments/parent_feed_comment_response.dart';
import 'package:grimity/domain/dto/feed_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/domain/repository/feed_comments_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeedCommentsRepository)
class FeedCommentsRepositoryImpl extends FeedCommentsRepository {
  final FeedCommentsAPI _feedCommentsAPI;

  FeedCommentsRepositoryImpl(this._feedCommentsAPI);

  @override
  Future<Result<void>> createFeedComment(CreateFeedCommentRequest request) async {
    try {
      await _feedCommentsAPI.createFeedComment(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<List<Comment>>> getFeedComments(String feedId) async {
    try {
      final List<ParentFeedCommentResponse> response = await _feedCommentsAPI.getFeedComments(feedId);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteFeedComment(String id) async {
    try {
      await _feedCommentsAPI.deleteFeedComment(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> likeFeedComment(String id) async {
    try {
      await _feedCommentsAPI.likeFeedComment(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> unlikeFeedComment(String id) async {
    try {
      await _feedCommentsAPI.unlikeFeedComment(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
