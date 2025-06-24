import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/link.dart';

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
    List<Link>? links,
    DateTime? createdAt,
    bool? hasNotification,
    int? followerCount,
    int? followingCount,
    int? feedCount,
    int? postCount,
    bool? isFollowing,
    List<Album>? albums,
    String? provider,
    String? email,
  }) = _User;

  factory User.empty() => const User(
    id: '',
    name: 'Lorem ipsum',
    url: '',
    followerCount: 0,
    followingCount: 0,
    feedCount: 0,
    postCount: 0,
    isFollowing: false,
    albums: [],
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static List<User> get emptyList => [User.empty(), User.empty(), User.empty()];
}
