import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/data/model/user/follow_user_response.dart';
import 'package:grimity/domain/entity/users.dart';

part 'my_followers_response.freezed.dart';
part 'my_followers_response.g.dart';

@Freezed(copyWith: false)
abstract class MyFollowersResponse with _$MyFollowersResponse implements CursorResponse {
  const factory MyFollowersResponse({String? nextCursor, required List<FollowUserResponse> followers}) =
      _MyFollowersResponse;

  factory MyFollowersResponse.fromJson(Map<String, dynamic> json) => _$MyFollowersResponseFromJson(json);
}

extension MyFollowersResponseX on MyFollowersResponse {
  Users toEntity() {
    return Users(users: followers.map((e) => e.toEntity()).toList(), nextCursor: nextCursor);
  }
}
