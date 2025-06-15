import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/post/post_base_response.dart';
import 'package:grimity/domain/entity/post.dart';

part 'my_post_response.freezed.dart';
part 'my_post_response.g.dart';

@Freezed(copyWith: false)
abstract class MyPostResponse with _$MyPostResponse implements PostBaseResponse {
  const MyPostResponse._();

  const factory MyPostResponse({
    required String id,
    required String title,
    required String content,
    String? thumbnail,
    required DateTime createdAt,
    required String type,
    required int viewCount,
    required int commentCount,
  }) = _MyPostResponse;

  factory MyPostResponse.fromJson(Map<String, dynamic> json) => _$MyPostResponseFromJson(json);
}

extension MyPostResponseX on MyPostResponse {
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
    );
  }
}

extension ListMyPostResponseX on List<MyPostResponse> {
  List<Post> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
