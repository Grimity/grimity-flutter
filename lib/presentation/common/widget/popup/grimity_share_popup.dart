import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/util/share_util.dart';

enum ShareContentType { feed, post, profile }

extension ShareContentTypeExtension on ShareContentType {
  String buildShareText({String? nickname}) {
    switch (this) {
      case ShareContentType.feed:
        return '이 그림 어때요?';
      case ShareContentType.post:
        return '이 글 같이 봐요!';
      case ShareContentType.profile:
        return '${nickname ?? ''}님의 프로필을 공유해보세요!';
    }
  }
}

/// 링크 공유 모달 바텀 시트
class GrimitySharePopup extends StatelessWidget {
  const GrimitySharePopup({
    super.key,
    required this.url,
    required this.shareContentType,
    this.nickname,
    required this.description,
    required this.imageUrl,
  });

  final String url;
  final ShareContentType shareContentType;

  // 트위터 프로필 공유 시 사용 nickname
  final String? nickname;

  // 카카오 공유시 사용
  // [description] Feed,Post - 제목, Profile - 유저명
  final String description;
  final String? imageUrl;

  Future<T?> show<T>(BuildContext context) {
    if (context.isMobile) {
      final bottomSheet = GdsBottomSheet(
        title: '글 공유',
        child: this,
      );

      return bottomSheet.open<T>(context);
    } else {
      final modal = GdsModal(
        title: '글 공유',
        body: this,
      );

      return modal.open<T>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing8,
      children: [
        GdsListItem.optionCard(
          text: '링크 복사하기',
          icon: GdsIcon.link,
          state: GdsListItemState.enabled,
          onTap: () async {
            await ShareUtil.copyLinkToClipboard(url);
            if (context.mounted) context.pop();
          },
        ),
        GdsListItem.optionCard(
          text: 'X로 공유',
          icon: GdsIcon.x,
          state: GdsListItemState.enabled,
          onTap: () async {
            await ShareUtil.shareToTwitter(text: shareContentType.buildShareText(nickname: nickname), url: url);
            if (context.mounted) context.pop();
          },
        ),
        GdsListItem.optionCard(
          text: '카카오톡으로 공유',
          icon: GdsIcon.kakaotalkSimple,
          state: GdsListItemState.enabled,
          onTap: () async {
            await ShareUtil.shareToKakao(description: description, imageUrl: imageUrl, linkUrl: url);
            if (context.mounted) context.pop();
          },
        ),
      ],
    );
  }
}
