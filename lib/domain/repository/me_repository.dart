import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/user.dart';

abstract class MeRepository {
  Future<Result<User>> getMe();
  Future<Result<void>> updateUser(UpdateUserRequest request);
  Future<Result<void>> deleteUser();
  Future<Result<void>> updateProfileImage(UpdateProfileImageRequestParam request);
  Future<Result<void>> deleteProfileImage();
  Future<Result<void>> updateBackgroundImage(UpdateBackgroundImageRequestParam request);
  Future<Result<void>> deleteBackgroundImage();
  Future<Result<List<Album>>> getMyAlbums();
}
