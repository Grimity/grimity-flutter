import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? image,
    required String url,
    String? backgroundImage,
    String? description,
    List<Map<String, String>>? links,
    DateTime? createdAt,
    bool? hasNotification,
    int? followerCount,
    int? followingCount,
    int? feedCount,
    int? postCount,
    bool? isFollowing,
    List<Map<String, dynamic>>? albums,
    String? provider,
    String? email,
  }) = _User;

  factory User.empty() => const User(id: '', name: '', url: '');
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
