import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feeds.freezed.dart';
part 'feeds.g.dart';

@freezed
abstract class Feeds with _$Feeds {
  const factory Feeds({required List<Feed> feeds, String? nextCursor, int? totalCount}) = _Feeds;

  factory Feeds.fromJson(Map<String, dynamic> json) => _$FeedsFromJson(json);

  factory Feeds.empty() => const Feeds(feeds: []);
}

extension FeedsX on Feeds {
  Feeds overrideLikeStateToTrue() {
    return copyWith(feeds: feeds.map((e) => e.copyWith(isLike: true)).toList());
  }

  Feeds overrideSaveStateToTrue() {
    return copyWith(feeds: feeds.map((e) => e.copyWith(isSave: true)).toList());
  }
}