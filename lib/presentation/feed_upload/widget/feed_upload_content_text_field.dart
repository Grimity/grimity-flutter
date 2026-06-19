import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadContentTextField extends HookConsumerWidget {
  const FeedUploadContentTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(feedUploadProvider).content;
    final controller = useTextEditingController(text: ref.watch(feedUploadProvider).content);

    useEffect(() {
      if (controller.text != content) {
        controller.text = content;
      }

      return null;
    }, [content]);

    return GdsTextArea.text(
      controller: controller,
      onChanged: ref.read(feedUploadProvider.notifier).updateContent,
      placeholder: '내용을 입력해주세요',
      maxLength: 500,
    );
  }
}
