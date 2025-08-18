import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/post_comments/create_post_comment_usecase.dart';
import 'package:grimity/domain/usecase/post_comments/delete_post_comment_usecase.dart';
import 'package:grimity/domain/usecase/post_comments/get_post_comments_usecase.dart';
import 'package:grimity/domain/usecase/post_comments/like_post_comment_usecase.dart';
import 'package:grimity/domain/usecase/post_comments/unlike_post_comment_usecase.dart';

final createPostCommentUseCase = getIt<CreatePostCommentUseCase>();
final getPostCommentsUseCase = getIt<GetPostCommentsUseCase>();
final deletePostCommentUseCase = getIt<DeletePostCommentUseCase>();
final likePostCommentUseCase = getIt<LikePostCommentUseCase>();
final unlikePostCommentUseCase = getIt<UnLikePostCommentUseCase>();
