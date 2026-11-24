// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/chat/models/chat_model.dart';
import 'package:grimity/presentation/image_viewer/pages/image_viewer_page.dart';
import 'package:pervice/pervice.dart';

/// 메시지 본문과 이미지, 답글을 정렬하여 표시하는 채팅 항목 위젯.
class ChatMessageItem extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.message,
    required this.model,
  });

  final GetChatsByIdUser service;
  final ChatMessageResponse message;
  final ValueState<ChatModel> model;

  @override
  Widget build(BuildContext context) {
    final isMine = message.user.id == profile.id;
    final images = message.images.toImages();

    // 상대방의 프로필 정보.
    final opponentUser = service.maybeData;

    // 답글 대상과 원본 메시지를 표시하는 위젯.
    GdsChatReply buildReply() => .new(
      isReplyToMe: !isMine,
      message: message.replyTo!.content ?? '사진',
      nickname: isMine ? opponentUser?.name ?? '...' : profile.name,
    );

    // 메시지 내용과 좋아요 상태를 표시하는 말풍선 위젯.
    GdsChatBubble buildBubble() => .new(
      message: message.content!,
      like: message.isLike,

      // 좋아요 추가 또는 해제 요청.
      onLike: () async {
        message.isLike
            ? await DeleteChatMessagesByIdLike(id: message.id).request()
            : await PutChatMessagesByIdLike(id: message.id).request();

        if (context.mounted) {
          context.pop();
        }
      },

      // 선택한 메시지를 답장 대상으로 지정.
      onReply: () {
        model.value.replyToId = message.id;
        model.notifyChanged();

        context.pop();
      },
    );

    // 채팅 이미지를 표시하고 선택한 이미지를 뷰어로 여는 위젯.
    GdsChatImages buildImages() => .new(
      images: images,
      onTap: (image) {
        final index = images.indexOf(image);

        // 선택한 이미지를 시작으로 이미지 뷰어 표시.
        context.push(
          ImageViewerPage(
            imageUrls: message.images,
            index: index,
            canDownload: true,
          ),
        );
      },
    );

    return Align(
      alignment: isMine ? .centerRight : .centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth - 80;

          return ConstrainedBox(
            constraints: .new(maxWidth: maxWidth),
            child: GdsChat(
              isMine: isMine,
              reply: message.replyTo == null ? null : buildReply(),
              bubble: message.content == null ? null : buildBubble(),
              images: images.isEmpty ? null : buildImages(),
            ),
          );
        },
      ),
    );
  }
}
