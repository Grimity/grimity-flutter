import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/domain/usecase/feed_comments_usecases.dart';
import 'package:grimity/domain/usecase/post_comments_usecases.dart';

enum CommentType { feed, post }

extension CommentTypeX on CommentType {
  UseCase get createCommentUseCase {
    switch (this) {
      case CommentType.feed:
        return createFeedCommentUseCase;
      case CommentType.post:
        return createPostCommentUseCase;
    }
  }

  UseCase get getCommentsUseCase {
    switch (this) {
      case CommentType.feed:
        return getFeedCommentsUseCase;
      case CommentType.post:
        return getPostCommentsUseCase;
    }
  }

  UseCase get deleteCommentsUseCase {
    switch (this) {
      case CommentType.feed:
        return deleteFeedCommentUseCase;
      case CommentType.post:
        return deletePostCommentUseCase;
    }
  }

  UseCase get likeCommentUseCase {
    switch (this) {
      case CommentType.feed:
        return likeFeedCommentUseCase;
      case CommentType.post:
        return likePostCommentUseCase;
    }
  }

  UseCase get unlikeCommentUseCase {
    switch (this) {
      case CommentType.feed:
        return unlikeFeedCommentUseCase;
      case CommentType.post:
        return unlikePostCommentUseCase;
    }
  }

  ReportRefType get reportRefType {
    switch (this) {
      case CommentType.feed:
        return ReportRefType.feedComment;
      case CommentType.post:
        return ReportRefType.postComment;
    }
  }
}
