// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

/// 글 답글 작성 시 멘션할 사용자의 정보.
typedef PostMention = ({
  String userName,
  String userId,
  String parentCommentId,
});

/// 글 상세에서 댓글과 답글을 작성하는 입력창.
class PostDetailInputBar extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.service,
  });

  final String id;
  final GetPostComments service;

  @override
  Widget build(BuildContext context) {
    final controller = context.useTextEditingController();
    final content = context.stateOf(() => '');
    final canSubmit = content.value.isNotEmpty;

    // SHARED STATE
    final mention = context.sharedStateOf<PostMention?>(
      () => null,
      key: ValueKey('post-$id:mention'),
    );

    final focusNode = context.sharedStateOf(
      FocusNode.new,
      key: ValueKey('post-$id:focus-node'),
    );

    return GdsInput.community(
      mentionText: mention.value?.userName,
      field: .new(
        placeholder: '댓글 입력',
        onChanged: content.setter,
        focusNode: focusNode.value,
        controller: controller,
      ),
      button: .new(
        enabled: canSubmit,
        label: '등록',
        onTap: () async {
          final postFeed = PostPostComments(
            request: .new(
              postId: id,
              content: content.value,
              mentionedUserId: mention.value?.userId,
              parentCommentId: mention.value?.parentCommentId,
            ),
          );

          await postFeed.request();

          // 등록 완료 후 입력 내용과 답글 대상 초기화.
          controller.clear();
          content.value = '';
          mention.value = null;

          // 기존 댓글 내용 새로고침.
          service.refresh();
        },
      ),
    );
  }
}
