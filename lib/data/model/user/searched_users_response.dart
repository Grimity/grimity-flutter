import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/shared/cursor_and_count_response.dart';
import 'package:grimity/data/model/user/searched_user_response.dart';
import 'package:grimity/domain/entity/users.dart';

part 'searched_users_response.freezed.dart';

part 'searched_users_response.g.dart';

@Freezed(copyWith: false)
abstract class SearchedUsersResponse with _$SearchedUsersResponse implements CursorAndCountResponse {
  const factory SearchedUsersResponse({
    String? nextCursor,
    required int totalCount,
    required List<SearchedUserResponse> users,
  }) = _SearchedUsersResponse;

  factory SearchedUsersResponse.fromJson(Map<String, dynamic> json) => _$SearchedUsersResponseFromJson(json);
}

extension SearchedUsersResponseX on SearchedUsersResponse {
  Users toEntity() {
    return Users(users: users.map((e) => e.toEntity()).toList(), nextCursor: nextCursor, totalCount: totalCount);
  }
}
