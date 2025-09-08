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
    User? writer,
    User? mentionedUser,
    List<Comment>? childComments,
    bool? isDeleted,
  }) = _Comment;

  const Comment._();

  bool get isDeletedComment => isDeleted == true;

  /// 익명화된 댓글(회원 탈퇴한 댓글)
  bool get isAnonymousUserComment => writer == null;

  factory Comment.empty() =>
      Comment(id: '', content: '', createdAt: DateTime.now(), likeCount: 0, isLike: false, writer: User.empty());

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  static List<Comment> get emptyList => [Comment.empty(), Comment.empty(), Comment.empty()];
}
