import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

/// 댓글 답글 작성 시 멘션할 사용자의 정보.
typedef FeedMention = ({
  String userName,
  String userId,
  String parentCommentId,
});

/// 피드 상세에서 댓글과 답글을 작성하는 입력창.
class FeedDetailInputBar extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.service,
  });

  final String id;
  final GetFeedComments service;

  @override
  Widget build(BuildContext context) {
    final controller = context.useTextEditingController();
    final content = context.stateOf(() => '');
    final loading = context.stateOf(() => false);
    final canSubmit = content.value.isNotEmpty;
    final isLoading = loading.value;

    // SHARED STATE
    final mention = context.sharedStateOf<FeedMention?>(
      () => null,
      key: ValueKey('feed-$id:mention'),
    );

    final focusNode = context.sharedStateOf(
      FocusNode.new,
      key: ValueKey('feed-$id:focus-node'),
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
        label: '등록',
        status: .from(
          enabled: canSubmit,
          loading: isLoading,
        ),
        onTap: () async {
          final postFeed = PostFeedComments(
            request: .new(
              feedId: id,
              content: content.value,
              mentionedUserId: mention.value?.userId,
              parentCommentId: mention.value?.parentCommentId,
            ),
          );

          await loading.run(() async {
            await postFeed.request();

            // 등록 완료 후 입력 내용과 답글 대상 초기화.
            controller.clear();
            content.value = '';
            mention.value = null;

            // 기존 댓글 내용 새로고침.
            service.refresh();
          });
        },
      ),
    );
  }
}
