import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';
import 'package:grimity/presentation/feed_detail/provider/comment_input_provider.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_comments_data_provider.dart';

class CommentWidget extends ConsumerWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.feedId,
    required this.feedAuthorId,
    this.parentComment,
  });

  final Comment comment;
  final String feedId;
  final String feedAuthorId;
  final Comment? parentComment;

  factory CommentWidget.parent({required Comment comment, required String feedId, required String feedAuthorId}) =>
      CommentWidget(comment: comment, feedId: feedId, feedAuthorId: feedAuthorId);

  factory CommentWidget.child({
    required Comment comment,
    required String feedId,
    required String feedAuthorId,
    required Comment parentComment,
  }) => CommentWidget(comment: comment, feedId: feedId, feedAuthorId: feedAuthorId, parentComment: parentComment);

  bool get isChild => parentComment != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMyComment = feedAuthorId == comment.writer.id;
    final isLike = comment.isLike ?? false;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isChild) ...[
            Gap(16),
            Padding(padding: EdgeInsets.all(6), child: Assets.icons.common.commentReplyPointer.svg()),
          ],
          GrimityUserImage(imageUrl: comment.writer.image, size: 24),
          Gap(6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(comment.writer.name, style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                        if (isMyComment) _buildAuthorChip(),
                        GrimityGrayCircle(),
                        Text(
                          comment.createdAt.toRelativeTime(),
                          style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                        ),
                      ],
                    ),
                    GrimityAnimationButton(
                      onTap: () => _showCommentMoreBottomSheet(context, ref, isMyComment),
                      child: Assets.icons.common.moreHoriz.svg(width: 20.w, height: 20.w),
                    ),
                  ],
                ),
                Gap(6),
                Row(
                  children: [
                    if (comment.mentionedUser != null) ...[
                      Text('@${comment.mentionedUser!.name}', style: AppTypeface.label3.copyWith(color: AppColor.main)),
                      Gap(8),
                    ],

                    Text(comment.content, style: AppTypeface.label3.copyWith(color: AppColor.gray800)),
                  ],
                ),
                Row(
                  children: [
                    GrimityAnimationButton(
                      child:
                          isLike
                              ? Assets.icons.common.heartFill.svg(width: 20.w, height: 20.w)
                              : Assets.icons.common.heart.svg(width: 20.w, height: 20.w),
                      onTap:
                          () => ref
                              .read(feedCommentsDataProvider(feedId).notifier)
                              .toggleCommentLike(comment.id, !isLike),
                    ),
                    if (comment.likeCount > 0) ...[
                      Gap(6),
                      Text('${comment.likeCount}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                    ],
                    Gap(16),
                    TextButton(
                      onPressed: () => updateCommentReplyState(ref),
                      child: Text('답글달기', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateCommentReplyState(WidgetRef ref) {
    if (isChild) {
      ref
          .read(commentInputProvider.notifier)
          .updateCommentReplyState(
            parentCommentId: parentComment!.id,
            mentionedUserId: comment.writer.id,
            replyUserName: comment.writer.name,
          );
    } else {
      ref
          .read(commentInputProvider.notifier)
          .updateCommentReplyState(parentCommentId: comment.id, replyUserName: comment.writer.name);
    }
  }

  void _showCommentMoreBottomSheet(BuildContext context, WidgetRef ref, bool isMyComment) {
    final buttons =
        isMyComment
            ? [
              GrimityModalButtonModel(
                title: '삭제하기',
                onTap: () {
                  context.pop();
                  ref.read(feedCommentsDataProvider(feedId).notifier).deleteComment(comment.id);
                },
              ),
              GrimityModalButtonModel(
                title: '답글달기',
                onTap: () {
                  context.pop();
                  updateCommentReplyState(ref);
                },
              ),
            ]
            : [
              GrimityModalButtonModel(
                title: '신고하기',
                onTap: () {
                  /// TODO 신고하기 페이지 구현 시
                },
              ),
              GrimityModalButtonModel(
                title: '답글달기',
                onTap: () {
                  context.pop();
                  updateCommentReplyState(ref);
                },
              ),
              GrimityModalButtonModel(
                title: '유저 프로필로 이동',
                onTap: () {
                  context.pop();
                  ProfileRoute(url: comment.writer.url).go(context);
                },
              ),
            ];

    GrimityModalBottomSheet.show(context, buttons: buttons);
  }

  Widget _buildAuthorChip() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: AppColor.mainSecondary,
        border: Border.all(color: Color(0xFF28C86E).withValues(alpha: 0.3)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Text('작성자', style: AppTypeface.caption3.copyWith(color: AppColor.main)),
    );
  }
}
