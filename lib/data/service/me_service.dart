import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/update_background_image_request.dart' as generated;
import 'package:grimity/data/gen/models/update_profile_image_request.dart' as generated;
import 'package:grimity/data/gen/models/update_subscription_request.dart' as generated;
import 'package:grimity/data/gen/models/update_user_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_me_mapper.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/entity/subscription.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MeService {
  final RestClient _client;

  MeService(this._client);

  Future<Result<User>> getMe() async {
    try {
      final response = await _client.me.meGetMe();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateUser(UpdateUserRequest request) async {
    try {
      await _client.me.meUpdateProfile(body: generated.UpdateUserRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteUser() async {
    try {
      await _client.me.meDeleteUser();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateProfileImage(UpdateProfileImageRequestParam request) async {
    try {
      await _client.me.meUpdateProfileImage(body: generated.UpdateProfileImageRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteProfileImage() async {
    try {
      await _client.me.meDeleteProfileImage();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateBackgroundImage(UpdateBackgroundImageRequestParam request) async {
    try {
      await _client.me.meUpdateBackgroundImage(
        body: generated.UpdateBackgroundImageRequest.fromJson(request.toJson()),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteBackgroundImage() async {
    try {
      await _client.me.meDeleteBackgroundImage();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<Album>>> getMyAlbums() async {
    try {
      final response = await _client.me.meGetMyAlbums();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feeds>> getLikeFeeds(int? size, String? cursor) async {
    try {
      final response = await _client.me.meGetMyLikeFeeds(size: size, cursor: cursor);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feeds>> getSaveFeeds(int? size, String? cursor) async {
    try {
      final response = await _client.me.meGetMySaveFeeds(size: size, cursor: cursor);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Posts>> getSavePosts(int page, int size) async {
    try {
      final response = await _client.me.meGetMySavePosts(page: page, size: size);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Users>> getMyFollowers(int? size, String? cursor) async {
    try {
      final result = await _client.me.meGetMyFollowers(size: size, cursor: cursor);
      return Result.success(result.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Users>> getMyFollowings(int? size, String? cursor) async {
    try {
      final result = await _client.me.meGetMyFollowings(size: size, cursor: cursor);
      return Result.success(result.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteFollowerById(String id) async {
    try {
      await _client.me.meDeleteMyFollower(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Subscription>> getSubscription() async {
    try {
      final result = await _client.me.meGetSubscriptions();
      return Result.success(result.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateSubscription(UpdateSubscriptionRequestParam request) async {
    try {
      await _client.me.meUpdateSubscriptions(body: generated.UpdateSubscriptionRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<User>>> getBlockedUsers() async {
    try {
      final result = await _client.me.meGetMyBlockings();
      return Result.success(result.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
