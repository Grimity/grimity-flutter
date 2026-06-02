import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/link.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
abstract class User with _$User {
  const User._();

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
    bool? hasUnreadChatMessage,
    int? followerCount,
    int? followingCount,
    int? feedCount,
    int? postCount,
    bool? isFollowing,
    List<Album>? albums,
    String? provider,
    String? email,
    bool? isBlocked,
    bool? isBlocking,
  }) = _User;

  /// '@'가 붙은 형태의 핸들 반환
  String get handle => '@$url';

  factory User.empty() => const User(
    id: '',
    url: 'lorem_ipsum',
    name: 'Lorem ipsum',
    followerCount: 0,
    followingCount: 0,
    feedCount: 0,
    postCount: 0,
    isFollowing: false,
    albums: [],
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static List<User> get emptyList => [
    User.empty(),
    User.empty(),
    User.empty(),
  ];
}
