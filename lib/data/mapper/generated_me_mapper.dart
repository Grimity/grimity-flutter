import 'package:grimity/data/gen/models/album_base_response.dart' as generated;
import 'package:grimity/data/gen/models/my_blockings_response.dart' as generated;
import 'package:grimity/data/gen/models/my_followers_response.dart' as generated;
import 'package:grimity/data/gen/models/my_followings_response.dart' as generated;
import 'package:grimity/data/gen/models/my_like_feeds_response.dart' as generated;
import 'package:grimity/data/gen/models/my_profile_response.dart' as generated;
import 'package:grimity/data/gen/models/my_save_posts_response.dart' as generated;
import 'package:grimity/data/gen/models/subscription_response.dart' as generated;
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/entity/subscription.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/data/mapper/json_normalizer.dart';

Map<String, dynamic> _json(Map<String, Object?> value) => normalizeJsonMap(value);

extension GeneratedMyProfileResponseMapper on generated.MyProfileResponse {
  User toEntity() => User.fromJson(_json(toJson()));
}

extension GeneratedAlbumBaseResponsesMapper on List<generated.AlbumBaseResponse> {
  List<Album> toEntity() => map((album) => Album.fromJson(_json(album.toJson()))).toList();
}

extension GeneratedMyLikeFeedsResponseMapper on generated.MyLikeFeedsResponse {
  Feeds toEntity() => Feeds.fromJson(_json(toJson()));
}

extension GeneratedMySavePostsResponseMapper on generated.MySavePostsResponse {
  Posts toEntity() => Posts.fromJson(_json(toJson()));
}

extension GeneratedMyFollowersResponseMapper on generated.MyFollowersResponse {
  Users toEntity() =>
      Users(users: followers.map((user) => User.fromJson(_json(user.toJson()))).toList(), nextCursor: nextCursor);
}

extension GeneratedMyFollowingsResponseMapper on generated.MyFollowingsResponse {
  Users toEntity() =>
      Users(users: followings.map((user) => User.fromJson(_json(user.toJson()))).toList(), nextCursor: nextCursor);
}

extension GeneratedSubscriptionResponseMapper on generated.SubscriptionResponse {
  Subscription toEntity() => Subscription.fromJson(_json(toJson()));
}

extension GeneratedMyBlockingsResponseMapper on generated.MyBlockingsResponse {
  List<User> toEntity() => users.map((user) => User.fromJson(_json(user.toJson()))).toList();
}
