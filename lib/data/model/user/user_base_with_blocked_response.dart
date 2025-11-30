import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'user_base_with_blocked_response.freezed.dart';

part 'user_base_with_blocked_response.g.dart';

@Freezed(copyWith: false)
abstract class UserBaseWithBlockedResponse with _$UserBaseWithBlockedResponse {
  const UserBaseWithBlockedResponse._();

  const factory UserBaseWithBlockedResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required bool isBlocked,
  }) = _UserBaseWithBlockedResponse;

  factory UserBaseWithBlockedResponse.fromJson(Map<String, dynamic> json) =>
      _$UserBaseWithBlockedResponseFromJson(json);
}

extension UserBaseWithBlockedResponseX on UserBaseWithBlockedResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      isBlocked: isBlocked,
    );
  }
}
