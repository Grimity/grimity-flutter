import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentInputBar extends HookConsumerWidget {
  const CommentInputBar({super.key, required this.id, required this.commentType});

  final String id;
  final CommentType commentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final state = ref.watch(commentInputProvider(commentType));
    final notifier = ref.read(commentInputProvider(commentType).notifier);
    final isNotEmpty = state.content.trim().isNotEmpty;

    useEffect(() {
      if (controller.text != state.content) {
        controller.text = state.content;
      }

      return null;
    }, [state.content]);

    void submit() {
      if (!isNotEmpty || state.uploading) return;

      notifier.createComment(id: id);
      FocusScope.of(context).unfocus();
    }

    final replyUserName = state.replyUserName;
    if (replyUserName != null) {
      return GdsInput.communityAnswer(
        replyUser: replyUserName,
        placeholder: commentType.hintText,
        mentionUser: replyUserName,
        controller: controller,
        focusNode: focusNode,
        buttonEnabled: isNotEmpty && !state.uploading,
        onChanged: notifier.updateContent,
        onButtonPressed: submit,
        onMentionClear: notifier.clearReplyState,
      );
    }

    return GdsInput.community(
      placeholder: commentType.hintText,
      controller: controller,
      focusNode: focusNode,
      buttonEnabled: isNotEmpty && !state.uploading,
      onChanged: notifier.updateContent,
      onButtonPressed: submit,
    );
  }
}
