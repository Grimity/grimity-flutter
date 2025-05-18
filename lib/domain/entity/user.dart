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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class Link with _$Link {
  const factory Link({required String linkName, required String link}) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}

@freezed
abstract class AlbumWithCount with _$AlbumWithCount {
  const factory AlbumWithCount({required String id, required String name, required int feedCount}) = _AlbumWithCount;

  factory AlbumWithCount.fromJson(Map<String, dynamic> json) => _$AlbumWithCountFromJson(json);
}

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({required List<String> subscription}) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}
