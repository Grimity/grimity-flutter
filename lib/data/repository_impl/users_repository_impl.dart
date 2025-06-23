import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/users_api.dart';
import 'package:grimity/data/model/feed/user_feeds_response.dart';
import 'package:grimity/data/model/post/my_post_response.dart';
import 'package:grimity/data/model/user/popular_user_response.dart';
import 'package:grimity/data/model/user/searched_users_response.dart';
import 'package:grimity/data/model/user/user_meta_response.dart';
import 'package:grimity/data/model/user/user_profile_response.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UsersRepository)
class UsersRepositoryImpl extends UsersRepository {
  final UsersAPI _usersAPI;

  UsersRepositoryImpl(this._usersAPI);

  @override
  Future<Result<void>> nameCheck(String name) async {
    try {
      await _usersAPI.nameCheck({'name': name});
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Users>> searchUser(SearchUserRequestParams request) async {
    try {
      final response = await _usersAPI.searchUser(request.keyword, request.cursor, request.size);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Users>> getPopularUsers() async {
    try {
      final response = await _usersAPI.getPopularUsers();
      final users = response.map((e) => e.toEntity()).toList();
      return Result.success(Users(users: users));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<User>> getProfileByUrl(String url) async {
    try {
      final response = await _usersAPI.getProfileByUrl(url);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<User>> getMetaByUrl(String url) async {
    try {
      final response = await _usersAPI.getMetaByUrl(url);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<User>> getUserById(String id) async {
    try {
      final response = await _usersAPI.getUserById(id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<User>> getMeta(String id) async {
    try {
      final response = await _usersAPI.getMeta(id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Feeds>> getFeeds(GetUserFeedsRequestParams request) async {
    try {
      final response = await _usersAPI.getFeeds(
        request.id,
        request.cursor,
        request.size,
        request.sort,
        request.albumId,
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<List<Post>>> getPosts(GetUserPostsRequestParams request) async {
    try {
      final response = await _usersAPI.getPosts(request.id, request.page, request.size);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> followUserById(String id) async {
    try {
      await _usersAPI.followUserById(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> unfollowUserById(String id) async {
    try {
      await _usersAPI.unfollowUserById(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
