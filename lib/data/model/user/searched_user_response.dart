import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'searched_user_response.freezed.dart';
part 'searched_user_response.g.dart';

@Freezed(copyWith: false)
abstract class SearchedUserResponse with _$SearchedUserResponse implements UserBaseResponse {
  const factory SearchedUserResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String description,
    String? backgroundImage,
    required bool isFollowing,
    required int followerCount,
  }) = _SearchedUserResponse;

  factory SearchedUserResponse.fromJson(Map<String, dynamic> json) => _$SearchedUserResponseFromJson(json);
}

extension SearchedUserResponseX on SearchedUserResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      description: description,
      backgroundImage: backgroundImage,
      isFollowing: isFollowing,
      followerCount: followerCount,
    );
  }
}
