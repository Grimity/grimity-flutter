import 'package:grimity/data/gen/models/my_post_response.dart' as generated;
import 'package:grimity/data/gen/models/popular_user_response.dart' as generated;
import 'package:grimity/data/gen/models/searched_users_response.dart' as generated;
import 'package:grimity/data/gen/models/user_feeds_response.dart' as generated;
import 'package:grimity/data/gen/models/user_meta_response.dart' as generated;
import 'package:grimity/data/gen/models/user_profile_response.dart' as generated;
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/data/mapper/json_normalizer.dart';

Map<String, dynamic> _json(Map<String, Object?> value) => normalizeJsonMap(value);

extension GeneratedSearchedUsersResponseMapper on generated.SearchedUsersResponse {
  Users toEntity() => Users.fromJson(_json(toJson()));
}

extension GeneratedPopularUserResponsesMapper on List<generated.PopularUserResponse> {
  Users toEntity() => Users(users: map((user) => User.fromJson(_json(user.toJson()))).toList());
}

extension GeneratedUserProfileResponseMapper on generated.UserProfileResponse {
  User toEntity() => User.fromJson(_json(toJson()));
}

extension GeneratedUserMetaResponseMapper on generated.UserMetaResponse {
  User toEntity() => User.fromJson(_json(toJson()));
}

extension GeneratedUserFeedsResponseMapper on generated.UserFeedsResponse {
  Feeds toEntity() => Feeds(
    nextCursor: nextCursor,
    feeds: feeds.map((feed) => Feed.fromJson(_json(feed.toJson()))).toList(),
  );
}

extension GeneratedMyPostResponsesMapper on List<generated.MyPostResponse> {
  List<Post> toEntity() => map((post) => Post.fromJson(_json(post.toJson()))).toList();
}
