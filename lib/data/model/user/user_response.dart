import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

@freezed
abstract class UserResponse with _$UserResponse {
  const factory UserResponse({required String id, required String name, String? image, required String url}) =
      _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
}

extension UserResponseX on UserResponse {
  User toEntity() {
    return User(id: id, name: name, image: image, url: url);
  }
}
