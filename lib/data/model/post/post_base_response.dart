import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/post.dart';

part 'post_base_response.freezed.dart';
part 'post_base_response.g.dart';

@Freezed(copyWith: false)
abstract class PostBaseResponse with _$PostBaseResponse {
  const factory PostBaseResponse({
    required String id,
    required String title,
    required String content,
    String? thumbnail,
    required DateTime createdAt,
  }) = _PostBaseResponse;

  factory PostBaseResponse.fromJson(Map<String, dynamic> json) => _$PostBaseResponseFromJson(json);
}

extension PostBaseResponseX on PostBaseResponse {
  Post toEntity() {
    return Post(id: id, title: title, content: content, thumbnail: thumbnail, createdAt: createdAt);
  }
}

extension ListPostBaseResponseX on List<PostBaseResponse> {
  List<Post> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
