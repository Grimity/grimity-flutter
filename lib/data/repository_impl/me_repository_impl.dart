import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/me_api.dart';
import 'package:grimity/data/model/user/my_followers_response.dart';
import 'package:grimity/data/model/user/my_followings_response.dart';
import 'package:grimity/data/model/user/my_profile_response.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MeRepository)
class MeRepositoryImpl extends MeRepository {
  final MeAPI _meAPI;

  MeRepositoryImpl(this._meAPI);

  @override
  Future<Result<User>> getMe() async {
    try {
      final MyProfileResponse response = await _meAPI.getMyProfile();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> updateUser(UpdateUserRequest request) async {
    try {
      await _meAPI.updateUser(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteUser() async {
    try {
      await _meAPI.deleteUser();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> updateProfileImage(UpdateProfileImageRequestParam request) async {
    try {
      await _meAPI.updateProfileImage(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteProfileImage() async {
    try {
      await _meAPI.deleteProfileImage();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> updateBackgroundImage(UpdateBackgroundImageRequestParam request) async {
    try {
      await _meAPI.updateBackgroundImage(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteBackgroundImage() async {
    try {
      await _meAPI.deleteBackgroundImage();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Users>> getMyFollowers(int? size, String? cursor) async {
    try {
      final result = await _meAPI.getMyFollowers(size, cursor);
      return Result.success(result.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Users>> getMyFollowings(int? size, String? cursor) async {
    try {
      final result = await _meAPI.getMyFollowings(size, cursor);
      return Result.success(result.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteFollowerById(String id) async {
    try {
      await _meAPI.deleteFollowerById(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

}
