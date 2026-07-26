import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'follow_user_response.freezed.dart';
part 'follow_user_response.g.dart';

@Freezed(copyWith: false)
abstract class FollowUserResponse with _$FollowUserResponse implements UserBaseResponse {
  const factory FollowUserResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String description,
    bool? isFollowing,
  }) = _FollowUserResponse;

  factory FollowUserResponse.fromJson(Map<String, dynamic> json) => _$FollowUserResponseFromJson(json);
}

extension FollowUserResponseX on FollowUserResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      description: description,
      isFollowing: isFollowing ?? true, // 자신이 팔로잉한 사용자를 조회한 경우 항상 true
    );
  }
}
