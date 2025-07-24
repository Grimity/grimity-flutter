import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/feed_comments/create_feed_comment_usecase.dart';
import 'package:grimity/domain/usecase/feed_comments/delete_feed_comment_usecase.dart';
import 'package:grimity/domain/usecase/feed_comments/get_feed_comments_usecase.dart';
import 'package:grimity/domain/usecase/feed_comments/like_feed_comment_usecase.dart';
import 'package:grimity/domain/usecase/feed_comments/unlike_feed_comment_usecase.dart';

final createFeedCommentUseCase = getIt<CreateFeedCommentUseCase>();
final getFeedCommentsUseCase = getIt<GetFeedCommentsUseCase>();
final deleteFeedCommentUseCase = getIt<DeleteFeedCommentUseCase>();
final likeFeedCommentUseCase = getIt<LikeFeedCommentUseCase>();
final unlikeFeedCommentUseCase = getIt<UnLikeFeedCommentUseCase>();
