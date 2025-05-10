import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required String title,
    required String content,
    String? thumbnail,
    required DateTime createdAt,
    String? type,
    int? viewCount,
    int? commentCount,
    User? author,
    int? likeCount,
    bool? isLike,
    bool? isSave,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.empty() => Post(
    id: '',
    title: 'Lorem ipsum dolor sit amet',
    content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
    createdAt: DateTime.now(),
  );
  static List<Post> get emptyList => [Post.empty(), Post.empty(), Post.empty()];
}
