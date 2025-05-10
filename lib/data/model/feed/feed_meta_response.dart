import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_meta_response.freezed.dart';
part 'feed_meta_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedMetaResponse with _$FeedMetaResponse implements FeedBaseResponse {
  const FeedMetaResponse._();

  const factory FeedMetaResponse({
    required String id,
    required String title,
    String? thumbnail,
    required String content,
    required DateTime createdAt,
    required List<String> tags,
  }) = _FeedMetaResponse;

  factory FeedMetaResponse.fromJson(Map<String, dynamic> json) => _$FeedMetaResponseFromJson(json);
}

extension FeedMetaResponseX on FeedMetaResponse {
  Feed toEntity() {
    return Feed(id: id, title: title, thumbnail: thumbnail, content: content, createdAt: createdAt, tags: tags);
  }
}

extension ListFeedMetaResponseX on List<FeedMetaResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
