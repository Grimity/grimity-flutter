import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/post/get_posts_usecase.dart';
import 'package:grimity/domain/usecase/post/get_post_detail_usecase.dart';

final getPostsUseCase = getIt<GetPostsUseCase>();
final getPostDetailUseCase = getIt<GetPostDetailUseCase>();
