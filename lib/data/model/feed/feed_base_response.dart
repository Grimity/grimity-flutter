import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_base_response.freezed.dart';
part 'feed_base_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedBaseResponse with _$FeedBaseResponse {
  const factory FeedBaseResponse({required String id, required String title, String? thumbnail}) = _FeedBaseResponse;

  factory FeedBaseResponse.fromJson(Map<String, dynamic> json) => _$FeedBaseResponseFromJson(json);
}

extension FeedBaseResponseX on FeedBaseResponse {
  Feed toEntity() {
    return Feed(id: id, title: title, thumbnail: thumbnail);
  }
}

extension ListFeedBaseResponseX on List<FeedBaseResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
