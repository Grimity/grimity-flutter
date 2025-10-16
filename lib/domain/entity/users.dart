import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'users.freezed.dart';

part 'users.g.dart';

@freezed
abstract class Users with _$Users {
  const factory Users({required List<User> users, String? nextCursor, int? totalCount}) = _Users;

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  factory Users.empty() => const Users(users: []);
}
