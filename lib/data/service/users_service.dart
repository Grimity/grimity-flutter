import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/check_name_request.dart' as generated;
import 'package:grimity/data/gen/models/user_feeds_sort.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_user_mapper.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UsersService {
  final RestClient _client;

  UsersService(this._client);

  Future<Result<void>> nameCheck(String name) async {
    try {
      await _client.users.userCheckName(body: generated.CheckNameRequest(name: name));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Users>> searchUser(SearchUserRequestParams request) async {
    try {
      final response = await _client.users.userSearchUser(
        keyword: request.keyword,
        cursor: request.cursor,
        size: request.size,
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Users>> getPopularUsers() async {
    try {
      final response = await _client.users.userGetPopularUsers();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<User>> getProfileByUrl(String url) async {
    try {
      final response = await _client.users.userGetProfileByUrl(url: url);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<User>> getMetaByUrl(String url) async {
    try {
      final response = await _client.users.userGetMetaByUrl(url: url);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<User>> getUserById(String id) async {
    try {
      final response = await _client.users.userGetUserById(id: id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<User>> getMeta(String id) async {
    try {
      final response = await _client.users.userGetMeta(id: id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feeds>> getFeeds(GetUserFeedsRequestParams request) async {
    try {
      final response = await _client.users.userGetFeeds(
        id: request.id,
        cursor: request.cursor,
        size: request.size,
        sort: request.sort == null ? null : generated.UserFeedsSort.fromJson(request.sort!.name),
        albumId: request.albumId,
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<Post>>> getPosts(GetUserPostsRequestParams request) async {
    try {
      final response = await _client.users.userGetPosts(id: request.id, page: request.page, size: request.size);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> followUserById(String id) async {
    try {
      await _client.users.userFollow(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> unfollowUserById(String id) async {
    try {
      await _client.users.userUnfollow(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> blockUserById(String id) async {
    try {
      await _client.users.userBlock(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> unblockUserById(String id) async {
    try {
      await _client.users.userUnblock(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
