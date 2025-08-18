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
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:grimity/presentation/comment/provider/comments_data_provider.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

class CommentWidget extends ConsumerWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.id,
    required this.authorId,
    this.parentComment,
    required this.commentType,
  });

  final Comment comment;
  final String id;
  final String authorId;
  final Comment? parentComment;
  final CommentType commentType;

  factory CommentWidget.parent({
    required Comment comment,
    required String id,
    required String authorId,
    required CommentType commentType,
  }) => CommentWidget(comment: comment, id: id, authorId: authorId, commentType: commentType);

  factory CommentWidget.child({
    required Comment comment,
    required String id,
    required String authorId,
    required Comment parentComment,
    required CommentType commentType,
  }) => CommentWidget(
    comment: comment,
    id: id,
    authorId: authorId,
    parentComment: parentComment,
    commentType: commentType,
  );

  bool get isChild => parentComment != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthor = authorId == comment.writer?.id;
    final isMyComment = comment.writer?.id == ref.watch(userAuthProvider)?.id;
    final isLike = comment.isLike ?? false;

    return Padding(
      padding: EdgeInsets.all(16),
      child:
          comment.isAnonymousUserComment
              ? Text('삭제된 댓글입니다.', style: AppTypeface.label2.copyWith(color: AppColor.gray500))
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isChild) ...[
                    Gap(16),
                    Padding(padding: EdgeInsets.all(6), child: Assets.icons.common.commentReplyPointer.svg()),
                  ],
                  if (commentType == CommentType.feed) ...[
                    GrimityUserImage(imageUrl: comment.writer!.image, size: 24),
                    Gap(6),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.isDeletedComment ? '탈퇴한 사용자' : comment.writer!.name,
                                  style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                                ),
                                if (isAuthor) _buildAuthorChip(),
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
                        RichText(
                          text: TextSpan(
                            children: [
                              if (comment.mentionedUser != null)
                                TextSpan(
                                  text: '@${comment.mentionedUser!.name} ',
                                  style: AppTypeface.label3.copyWith(color: AppColor.main),
                                ),
                              TextSpan(
                                text: comment.content,
                                style: AppTypeface.label3.copyWith(color: AppColor.gray800),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GrimityAnimationButton(
                              child:
                                  /// TODO Post 게시글의 경우 따봉 아이콘으로 변경
                                  isLike
                                      ? Assets.icons.common.heartFill.svg(width: 20.w, height: 20.w)
                                      : Assets.icons.common.heart.svg(width: 20.w, height: 20.w),
                              onTap:
                                  () => ref
                                      .read(commentsDataProvider(commentType, id).notifier)
                                      .toggleCommentLike(comment.id, !isLike),
                            ),
                            if (comment.likeCount > 0) ...[
                              Gap(6),
                              Text(
                                '${comment.likeCount}',
                                style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                              ),
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
          .read(commentInputProvider(commentType).notifier)
          .updateCommentReplyState(
            parentCommentId: parentComment!.id,
            mentionedUserId: comment.writer!.id,
            replyUserName: comment.writer!.name,
          );
    } else {
      ref
          .read(commentInputProvider(commentType).notifier)
          .updateCommentReplyState(parentCommentId: comment.id, replyUserName: comment.writer!.name);
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
                  ref.read(commentsDataProvider(commentType, id).notifier).deleteComment(comment.id);
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
                  ProfileRoute(url: comment.writer!.url).go(context);
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
