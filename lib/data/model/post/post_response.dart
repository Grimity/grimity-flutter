import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/post/post_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/post.dart';

part 'post_response.freezed.dart';
part 'post_response.g.dart';

@Freezed(copyWith: false)
abstract class PostResponse with _$PostResponse implements PostBaseResponse {
  const PostResponse._();

  const factory PostResponse({
    required String id,
    required String title,
    required String content,
    String? thumbnail,
    required DateTime createdAt,
    required String type,
    required int viewCount,
    required int commentCount,
    required UserResponse author,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);
}

extension PostResponseX on PostResponse {
  Post toEntity() {
    return Post(
      id: id,
      title: title,
      content: content,
      thumbnail: thumbnail,
      createdAt: createdAt,
      type: type,
      viewCount: viewCount,
      commentCount: commentCount,
      author: author.toEntity(),
    );
  }
}

extension ListPostResponseX on List<PostResponse> {
  List<Post> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
