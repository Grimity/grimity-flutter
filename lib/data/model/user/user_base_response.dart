import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'user_base_response.freezed.dart';
part 'user_base_response.g.dart';

@Freezed(copyWith: false)
abstract class UserBaseResponse with _$UserBaseResponse {
  const UserBaseResponse._();

  const factory UserBaseResponse({required String id, required String name, String? image, required String url}) =
      _UserBaseResponse;

  factory UserBaseResponse.fromJson(Map<String, dynamic> json) => _$UserBaseResponseFromJson(json);
}

extension UserBaseResponseX on UserBaseResponse {
  User toEntity() {
    return User(id: id, name: name, image: image, url: url);
  }
}
