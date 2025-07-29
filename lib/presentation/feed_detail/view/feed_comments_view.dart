import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/presentation/feed_detail/model/comment_item.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_comments_data_provider.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_comment_widget.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_empty_comment_widget.dart';

/// 피드 댓글 View
class FeedCommentsView extends ConsumerWidget {
  const FeedCommentsView({super.key, required this.feedId, required this.commentCount, required this.feedAuthorId});

  final String feedId;
  final String feedAuthorId;
  final int commentCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(feedCommentsDataProvider(feedId));

    return commentsAsync.maybeWhen(
      data: (comments) {
        final items = flattenComments(comments);

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
              if (comments.isEmpty) ...[
                EmptyCommentWidget(),
              ] else ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return item is ChildCommentItem
                        ? CommentWidget.child(
                          comment: item.comment,
                          feedId: feedId,
                          feedAuthorId: feedAuthorId,
                          parentComment: item.parentComment,
                        )
                        : CommentWidget.parent(comment: item.comment, feedId: feedId, feedAuthorId: feedAuthorId);
                  },
                  separatorBuilder: (context, index) => Divider(color: AppColor.gray300, height: 1, thickness: 1),
                  itemCount: items.length,
                ),
              ],
            ],
          ),
        );
      },
      orElse: () {
        /// TODO : 댓글로딩 + 댓글 로드 실패 화면 구현 필요
        return Text('loading + error');
      },
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
