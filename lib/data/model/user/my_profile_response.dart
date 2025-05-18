import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/link_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'my_profile_response.freezed.dart';
part 'my_profile_response.g.dart';

@Freezed(copyWith: false)
abstract class MyProfileResponse with _$MyProfileResponse implements UserBaseResponse {
  const factory MyProfileResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String provider,
    required String email,
    String? backgroundImage,
    required String description,
    required List<LinkResponse> links,
    required DateTime createdAt,
    required bool hasNotification,
    required int followerCount,
    required int followingCount,
  }) = _MyProfileResponse;

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) => _$MyProfileResponseFromJson(json);
}

extension MyProfileResponseX on MyProfileResponse {
  User toEntity() {
    return User(
      id: id,
      name: name,
      image: image,
      url: url,
      provider: provider,
      email: email,
      backgroundImage: backgroundImage,
      description: description,
      links: links.map((e) => {'linkName': e.linkName, 'link': e.link}).toList(),
      createdAt: createdAt,
      hasNotification: hasNotification,
      followerCount: followerCount,
      followingCount: followingCount,
    );
  }
}
