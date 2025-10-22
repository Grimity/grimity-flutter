import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/presentation/comment/widget/comment_widget.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/model/comment_item.dart';
import 'package:grimity/presentation/comment/provider/comments_data_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 댓글 View
class CommentsView extends ConsumerWidget {
  const CommentsView({
    super.key,
    required this.id,
    required this.commentCount,
    required this.authorId,
    required this.commentType,
  });

  final String id;
  final String authorId;
  final int commentCount;
  final CommentType commentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(commentsDataProvider(commentType, id));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              spacing: 6,
              children: [
                Text('댓글', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
                Text('$commentCount', style: AppTypeface.body1.copyWith(color: AppColor.main)),
              ],
            ),
          ),
          commentsAsync.when(
            data:
                (comments) => _CommentListView(
                  id: id,
                  authorId: authorId,
                  commentItems: flattenComments(comments),
                  commentType: commentType,
                ),
            loading:
                () => Skeletonizer(
                  child: _CommentListView(
                    id: id,
                    authorId: authorId,
                    commentItems: flattenComments(Comment.emptyList),
                    commentType: commentType,
                  ),
                ),
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(commentsDataProvider(commentType, id))),
          ),
        ],
      ),
    );
  }

  List<CommentItem> flattenComments(List<Comment> comments) {
    final result = <CommentItem>[];

    for (final parent in comments) {
      result.add(ParentCommentItem(parent));

      if (parent.childComments != null) {
        result.addAll(parent.childComments!.map((child) => ChildCommentItem(child, parent)));
      }
    }

    return result;
  }
}

class _CommentListView extends StatelessWidget {
  const _CommentListView({
    required this.id,
    required this.authorId,
    required this.commentItems,
    required this.commentType,
  });

  final String id;
  final String authorId;
  final List<CommentItem> commentItems;
  final CommentType commentType;

  @override
  Widget build(BuildContext context) {
    if (commentItems.isEmpty) {
      return GrimityStateView.commentReply(
        title: '아직 댓글이 없어요',
        subTitle: '댓글을 써서 생각을 나눠보세요',
        padding: EdgeInsets.symmetric(vertical: 30),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = commentItems[index];

        return item is ChildCommentItem
            ? CommentWidget.child(
              comment: item.comment,
              id: id,
              authorId: authorId,
              parentComment: item.parentComment,
              commentType: commentType,
            )
            : CommentWidget.parent(comment: item.comment, id: id, authorId: authorId, commentType: commentType);
      },
      separatorBuilder: (context, index) => Divider(color: AppColor.gray300, height: 1, thickness: 1),
      itemCount: commentItems.length,
    );
  }
}
