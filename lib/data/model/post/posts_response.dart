import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/post/post_response.dart';
import 'package:grimity/data/model/shared/total_count_response.dart';
import 'package:grimity/domain/entity/posts.dart';

part 'posts_response.freezed.dart';

part 'posts_response.g.dart';

@Freezed(copyWith: false)
abstract class PostsResponse with _$PostsResponse implements TotalCountResponse {
  const PostsResponse._();

  const factory PostsResponse({required int totalCount, required List<PostResponse> posts}) = _PostsResponse;

  factory PostsResponse.fromJson(Map<String, dynamic> json) => _$PostsResponseFromJson(json);
}

extension PostsResponseX on PostsResponse {
  Posts toEntity() {
    return Posts(posts: posts.toEntity(), totalCount: totalCount);
  }
}
