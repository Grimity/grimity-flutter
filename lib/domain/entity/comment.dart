import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/user.dart';

part 'comment.freezed.dart';

part 'comment.g.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String content,
    required DateTime createdAt,
    required int likeCount,
    bool? isLike,
    required User writer,
    User? mentionedUser,
    List<Comment>? childComments,
  }) = _Comment;

  factory Comment.empty() =>
      Comment(id: '', content: '', createdAt: DateTime.now(), likeCount: 0, isLike: false, writer: User.empty());

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  static List<Comment> get emptyList => [Comment.empty(), Comment.empty(), Comment.empty()];
}
