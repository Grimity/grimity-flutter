import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';

abstract class MeRepository {
  Future<Result<User>> getMe();
  Future<Result<void>> updateUser(UpdateUserRequest request);
  Future<Result<void>> deleteUser();
  Future<Result<void>> updateProfileImage(UpdateProfileImageRequestParam request);
  Future<Result<void>> deleteProfileImage();
  Future<Result<void>> updateBackgroundImage(UpdateBackgroundImageRequestParam request);
  Future<Result<void>> deleteBackgroundImage();
  Future<Result<Users>> getMyFollowers(int? size, String? cursor);
  Future<Result<Users>> getMyFollowings(int? size, String? cursor);
  Future<Result<void>> deleteFollowerById(String id);
  Future<Result<Feeds>> getLikeFeeds(int? size, String? cursor);
  Future<Result<Feeds>> getSaveFeeds(int? size, String? cursor);
  Future<Result<Posts>> getSavePosts(int page, int size);
}
