import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'user_meta_response.freezed.dart';
part 'user_meta_response.g.dart';

@Freezed(copyWith: false)
abstract class UserMetaResponse with _$UserMetaResponse {
  const factory UserMetaResponse({
    required String id,
    required String name,
    String? image,
    required String url,
    required String description,
  }) = _UserMetaResponse;

  factory UserMetaResponse.fromJson(Map<String, dynamic> json) => _$UserMetaResponseFromJson(json);
}

extension UserMetaResponseX on UserMetaResponse {
  User toEntity() {
    return User(id: id, name: name, image: image, url: url, description: description);
  }
}
