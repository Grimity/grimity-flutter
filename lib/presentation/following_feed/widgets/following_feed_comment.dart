import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 팔로잉 피드의 댓글을 표시하는 위젯.
class FollowingFeedComment extends StatelessWidget {
  const new({
    super.key,
    required this.onTap,
    required this.profile,
    required this.content,
  });

  final VoidCallback onTap;
  final ImageProvider? profile;
  final String content;

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: onTap,
      child: GdsContainer(
        color: .surfaceGraySubtlest,
        radius: .md,
        border: .all(color: .borderGraySubtler),
        padding: .all(12),
        child: Row(
          spacing: 12,
          children: [
            // 프로필 이미지 표시
            GdsProfile(size: .md, image: profile),

            // 댓글 본문 표시 / 최대 2줄
            Expanded(
              child: GdsText(
                content,
                color: .textGrayBold,
                style: .label4,
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
