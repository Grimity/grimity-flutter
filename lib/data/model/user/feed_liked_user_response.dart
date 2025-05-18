import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'feed_liked_user_response.freezed.dart';
part 'feed_liked_user_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedLikedUserResponse with _$FeedLikedUserResponse {
  const factory FeedLikedUserResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String description,
  }) = _FeedLikedUserResponse;

  factory FeedLikedUserResponse.fromJson(Map<String, dynamic> json) => _$FeedLikedUserResponseFromJson(json);
}

extension FeedLikedUserResponseX on FeedLikedUserResponse {
  User toEntity() {
    return User(id: id, name: name, image: image, url: url, description: description);
  }
}
