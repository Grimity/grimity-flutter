// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_image.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/extensions/string_extension.dart';
import 'package:grimity/presentation/chat/models/chat_model.dart';
import 'package:grimity/presentation/chat/services/chat_service.dart';
import 'package:grimity/presentation/gallery/pages/gallery_page.dart';
import 'package:pervice/pervice.dart';

/// 메시지와 이미지를 작성하고 답장 대상과 함께 전송하는 채팅 입력창.
class ChatInputBar extends StatelessWidget {
  const new({
    super.key,
    required this.model,
    required this.userService,
    required this.chatService,
  });

  final ValueState<ChatModel> model;
  final GetChatsByIdUser userService;
  final ChatService chatService;

  /// 선택한 이미지를 업로드하고 메시지를 전송합니다.
  Future<void> onSubmit() async {
    final data = model.value;
    final images = await AppImage.resolve(data.images, .chat);

    await chatService.sendMessage(
      content: data.content.trim().orNull,
      images: images.names,
      replyToId: data.replyToId,
    );

    // 전송이 완료되면 입력 내용과 이미지, 답장 대상 초기화.
    model.value = ChatModel();
  }

  @override
  Widget build(BuildContext context) {
    final data = model.value;
    final reply = chatService.maybeData
        ?.expand((page) => page.messages)
        .where((message) => message.id == data.replyToId)
        .firstOrNull;

    // 상대방의 프로필 정보.
    final opponentUser = userService.maybeData;

    // 상대방과의 차단 관계 여부.
    final isBlocked = opponentUser?.isBlocked ?? false;
    final isBlocking = opponentUser?.isBlocking ?? false;

    // 선택된 답장 대상의 닉네임과 메시지를 표시하는 위젯.
    GdsChatInputReply buildReply() => .new(
      isReplyToMe: reply!.user.id == profile.id,
      nickname: reply.user.name,
      message: reply.content ?? '사진',
    );

    /// 입력한 메시지 내용을 모델에 반영합니다.
    void onChanged(String newValue) {
      data.content = newValue;
      model.notifyChanged();
    }

    // 갤러리에서 선택한 이미지를 메시지에 첨부.
    void onCameraTap() async {
      final remaining = 9 - data.images.length;
      if (remaining == 0) {
        GdsToast.show('이미지는 최대 9장까지 첨부할 수 있어요', status: .negative);
        return;
      }

      final images = await context.push<List<ImageProvider>>(
        GalleryPage(maxCount: remaining),
      );

      // 갤러리에서 선택한 이미지를 첨부 목록에 추가.
      if (images != null && context.mounted) {
        data.images.addAll(images);
        model.notifyChanged();
      }
    }

    return GdsChatInput(
      text: data.content,
      enabled: !(isBlocked || isBlocking),
      onSubmit: onSubmit,
      canSubmit: data.canSubmit,
      reply: reply == null ? null : buildReply(),
      onChanged: onChanged,
      onCameraTap: onCameraTap,
    );
  }
}
