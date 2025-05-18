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
  }) = _FollowUserResponse;

  factory FollowUserResponse.fromJson(Map<String, dynamic> json) => _$FollowUserResponseFromJson(json);
}

extension FollowUserResponseX on FollowUserResponse {
  User toEntity() {
    return User(id: id, name: name, image: image, url: url, description: description);
  }
}
