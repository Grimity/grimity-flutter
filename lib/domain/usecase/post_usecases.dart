import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/post/delete_post_usecase.dart';
import 'package:grimity/domain/usecase/post/get_posts_usecase.dart';
import 'package:grimity/domain/usecase/post/get_post_detail_usecase.dart';
import 'package:grimity/domain/usecase/post/like_post_usecase.dart';
import 'package:grimity/domain/usecase/post/remove_saved_post_usecase.dart';
import 'package:grimity/domain/usecase/post/save_post_usecase.dart';
import 'package:grimity/domain/usecase/post/search_posts_usecase.dart';
import 'package:grimity/domain/usecase/post/unlike_post_usecase.dart';

final getPostsUseCase = getIt<GetPostsUseCase>();
final searchPostsUseCase = getIt<SearchPostsUseCase>();
final getPostDetailUseCase = getIt<GetPostDetailUseCase>();
final deletePostUseCase = getIt<DeletePostUseCase>();
final likePostUseCase = getIt<LikePostUseCase>();
final unlikePostUseCase = getIt<UnLikePostUseCase>();
final savePostUseCase = getIt<SavePostUseCase>();
final removeSavedPostUseCase = getIt<RemoveSavedPostUseCase>();
