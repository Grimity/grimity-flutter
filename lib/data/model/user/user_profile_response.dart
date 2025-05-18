import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/link_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'user_profile_response.freezed.dart';
part 'user_profile_response.g.dart';

@Freezed(copyWith: false)
abstract class UserProfileResponse with _$UserProfileResponse implements UserBaseResponse {
  const factory UserProfileResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String description,
    String? backgroundImage,
    required List<LinkResponse> links,
    required int followerCount,
    required int followingCount,
    required int feedCount,
    required int postCount,
    required bool isFollowing,
    required List<dynamic> albums,
  }) = _UserProfileResponse;

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => _$UserProfileResponseFromJson(json);
}

extension UserProfileResponseX on UserProfileResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      description: description,
      backgroundImage: backgroundImage,
      links: links.map((e) => {'linkName': e.linkName, 'link': e.link}).toList(),
      followerCount: followerCount,
      followingCount: followingCount,
      feedCount: feedCount,
      postCount: postCount,
      isFollowing: isFollowing,
      albums: albums.map((e) => {'id': e['id'], 'name': e['name'], 'feedCount': e['feedCount']}).toList(),
    );
  }
}
