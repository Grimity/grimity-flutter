import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/user.dart';

part 'my_blockings_response.freezed.dart';

part 'my_blockings_response.g.dart';

@Freezed(copyWith: false)
abstract class MyBlockingsResponse with _$MyBlockingsResponse {
  factory MyBlockingsResponse({
    required List<UserBaseResponse> users,
  }) = _MyBlockingsResponse;

  factory MyBlockingsResponse.fromJson(Map<String, dynamic> json) => _$MyBlockingsResponseFromJson(json);
}

extension MyBlockingsResponseX on MyBlockingsResponse {
  List<User> toEntity() {
    return users.map((e) => e.toEntity()).toList();
  }
}
