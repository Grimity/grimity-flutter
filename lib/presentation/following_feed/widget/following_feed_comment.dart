import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/comment.dart';

class FollowingFeedComment extends StatelessWidget {
  const FollowingFeedComment({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Container(
      padding: EdgeInsets.all(GdsSpacing.spacing12),
      decoration: BoxDecoration(
        color: colors.surface.graySubtlest,
        borderRadius: BorderRadius.circular(GdsRadius.md),
        border: Border.all(color: colors.border.graySubtler),
      ),
      child: Row(
        spacing: GdsSpacing.spacing12,
        children: [
          GdsPersonAvatar(
            size: GdsAvatarSize.md,
            imageUrl: comment.mentionedUser?.image,
          ),
          Expanded(
            child: Text(
              comment.content,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GdsTypography.label4.copyWith(color: colors.text.grayBold),
            ),
          ),
        ],
      ),
    );
  }
}
