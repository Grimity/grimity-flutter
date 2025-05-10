import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/post/my_post_response.dart';
import 'package:grimity/data/model/shared/total_count_response.dart';
import 'package:grimity/domain/entity/post.dart';

part 'my_save_posts_response.freezed.dart';
part 'my_save_posts_response.g.dart';

@Freezed(copyWith: false)
abstract class MySavePostsResponse with _$MySavePostsResponse implements TotalCountResponse {
  const MySavePostsResponse._();

  const factory MySavePostsResponse({required int totalCount, required List<MyPostResponse> posts}) =
      _MySavePostsResponse;

  factory MySavePostsResponse.fromJson(Map<String, dynamic> json) => _$MySavePostsResponseFromJson(json);
}

extension MySavePostsResponseX on MySavePostsResponse {
  List<Post> toEntity() {
    return posts.map((e) => e.toEntity()).toList();
  }
}
