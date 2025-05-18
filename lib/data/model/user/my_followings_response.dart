import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/data/model/user/follow_user_response.dart';

part 'my_followings_response.freezed.dart';
part 'my_followings_response.g.dart';

@Freezed(copyWith: false)
abstract class MyFollowingsResponse with _$MyFollowingsResponse implements CursorResponse {
  const factory MyFollowingsResponse({String? nextCursor, required List<FollowUserResponse> followings}) =
      _MyFollowingsResponse;

  factory MyFollowingsResponse.fromJson(Map<String, dynamic> json) => _$MyFollowingsResponseFromJson(json);
}
