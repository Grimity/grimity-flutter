import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/post/post_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/post.dart';

part 'post_detail_response.freezed.dart';
part 'post_detail_response.g.dart';

@Freezed(copyWith: false)
abstract class PostDetailResponse with _$PostDetailResponse implements PostResponse {
  const PostDetailResponse._();

  const factory PostDetailResponse({
    required String id,
    required String title,
    required String content,
    String? thumbnail,
    required DateTime createdAt,
    required String type,
    required int viewCount,
    required int commentCount,
    required UserBaseResponse author,
    required int likeCount,
    required bool isLike,
    required bool isSave,
  }) = _PostDetailResponse;

  factory PostDetailResponse.fromJson(Map<String, dynamic> json) => _$PostDetailResponseFromJson(json);
}

extension PostDetailResponseX on PostDetailResponse {
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
      likeCount: likeCount,
      isLike: isLike,
      isSave: isSave,
    );
  }
}

extension ListPostDetailResponseX on List<PostDetailResponse> {
  List<Post> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
