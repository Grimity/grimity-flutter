import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/me/delete_background_image_usecase.dart';
import 'package:grimity/domain/usecase/me/delete_profile_image_usecase.dart';
import 'package:grimity/domain/usecase/me/delete_user_usecase.dart';
import 'package:grimity/domain/usecase/me/get_me_usecase.dart';
import 'package:grimity/domain/usecase/me/get_my_albums_usecase.dart';
import 'package:grimity/domain/usecase/me/update_background_image_usecase.dart';
import 'package:grimity/domain/usecase/me/update_profile_image_usecase.dart';
import 'package:grimity/domain/usecase/me/update_user_usecase.dart';

final getMeUseCase = getIt<GetMeUseCase>();
final updateUserUseCase = getIt<UpdateUserUseCase>();
final deleteUserUseCase = getIt<DeleteUserUseCase>();

final updateProfileImageUseCase = getIt<UpdateProfileImageUseCase>();
final deleteProfileImageUseCase = getIt<DeleteProfileImageUseCase>();

final updateBackgroundImageUseCase = getIt<UpdateBackgroundImageUseCase>();
final deleteBackgroundImageUseCase = getIt<DeleteBackgroundImageUseCase>();

final getMyAlbumsUseCase = getIt<GetMyAlbumsUseCase>();