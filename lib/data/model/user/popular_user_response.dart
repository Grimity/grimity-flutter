import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'popular_user_response.freezed.dart';
part 'popular_user_response.g.dart';

@Freezed(copyWith: false)
abstract class PopularUserResponse with _$PopularUserResponse implements UserBaseResponse {
  const factory PopularUserResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String description,
    required int followerCount,
    required bool isFollowing,
    required List<String> thumbnails,
  }) = _PopularUserResponse;

  factory PopularUserResponse.fromJson(Map<String, dynamic> json) => _$PopularUserResponseFromJson(json);
}

extension PopularUserResponseX on PopularUserResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      description: description,
      followerCount: followerCount,
      isFollowing: isFollowing,
    );
  }
}
