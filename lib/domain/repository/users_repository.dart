import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/users.dart';

abstract class UsersRepository {
  Future<Result<void>> nameCheck(String name);

  Future<Result<Users>> searchUser(SearchUserRequestParams request);

  Future<Result<Users>> getPopularUsers();

  Future<Result<User>> getProfileByUrl(String url);

  Future<Result<User>> getMetaByUrl(String url);

  Future<Result<User>> getUserById(String id);

  Future<Result<User>> getMeta(String id);

  Future<Result<Feeds>> getFeeds(GetUserFeedsRequestParams request);

  Future<Result<List<Post>>> getPosts(GetUserPostsRequestParams request);
}
