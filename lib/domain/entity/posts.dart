import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/post.dart';

part 'posts.freezed.dart';

part 'posts.g.dart';

@freezed
abstract class Posts with _$Posts {
  const factory Posts({required List<Post> posts, String? nextCursor, int? totalCount}) = _Posts;

  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);

  factory Posts.empty() => const Posts(posts: []);
}

extension PostsX on Posts {
  Posts overrideSaveStateToTrue() {
    return copyWith(posts: posts.map((e) => e.copyWith(isSave: true)).toList());
  }
}