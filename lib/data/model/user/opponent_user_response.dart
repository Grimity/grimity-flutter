import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'opponent_user_response.freezed.dart';

part 'opponent_user_response.g.dart';

@Freezed(copyWith: false)
abstract class OpponentUserResponse with _$OpponentUserResponse {
  const OpponentUserResponse._();

  const factory OpponentUserResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required bool isBlocked,
    required bool isBlocking,
  }) = _OpponentUserResponse;

  factory OpponentUserResponse.fromJson(Map<String, dynamic> json) => _$OpponentUserResponseFromJson(json);
}

extension OpponentUserResponseX on OpponentUserResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      isBlocked: isBlocked,
      isBlocking: isBlocking,
    );
  }
}
