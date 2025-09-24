import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/me/delete_background_image_usecase.dart';
import 'package:grimity/domain/usecase/me/delete_follower_usecase.dart';
import 'package:grimity/domain/usecase/me/delete_profile_image_usecase.dart';
import 'package:grimity/domain/usecase/me/delete_user_usecase.dart';
import 'package:grimity/domain/usecase/me/get_like_feeds_usecase.dart';
import 'package:grimity/domain/usecase/me/get_me_usecase.dart';
import 'package:grimity/domain/usecase/me/get_my_albums_usecase.dart';
import 'package:grimity/domain/usecase/me/get_my_followers_usecase.dart';
import 'package:grimity/domain/usecase/me/get_my_followings_usecase.dart';
import 'package:grimity/domain/usecase/me/get_save_feeds_usecase.dart';
import 'package:grimity/domain/usecase/me/get_save_posts_usecase.dart';
import 'package:grimity/domain/usecase/me/get_subscription_usecase.dart';
import 'package:grimity/domain/usecase/me/update_background_image_usecase.dart';
import 'package:grimity/domain/usecase/me/update_profile_image_usecase.dart';
import 'package:grimity/domain/usecase/me/update_subscription_usecase.dart';
import 'package:grimity/domain/usecase/me/update_user_usecase.dart';

final getMeUseCase = getIt<GetMeUseCase>();
final updateUserUseCase = getIt<UpdateUserUseCase>();
final deleteUserUseCase = getIt<DeleteUserUseCase>();

final updateProfileImageUseCase = getIt<UpdateProfileImageUseCase>();
final deleteProfileImageUseCase = getIt<DeleteProfileImageUseCase>();

final updateBackgroundImageUseCase = getIt<UpdateBackgroundImageUseCase>();
final deleteBackgroundImageUseCase = getIt<DeleteBackgroundImageUseCase>();

final getMyAlbumsUseCase = getIt<GetMyAlbumsUseCase>();
final getMyFollowersUseCase = getIt<GetMyFollowersUseCase>();
final getMyFollowingsUseCase = getIt<GetMyFollowingsUseCase>();
final deleteFollowerByIdUseCase = getIt<DeleteFollowerByIdUseCase>();

final getSaveFeedsUseCase = getIt<GetSaveFeedsUseCase>();
final getLikeFeedsUseCase = getIt<GetLikeFeedsUseCase>();
final getSavePostsUseCase = getIt<GetSavePostsUseCase>();

final getSubscriptionUseCase = getIt<GetSubscriptionUseCase>();
final updateSubscriptionUseCase = getIt<UpdateSubscriptionUseCase>();
