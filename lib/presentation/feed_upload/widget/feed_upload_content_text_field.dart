import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadContentTextField extends HookConsumerWidget {
  const FeedUploadContentTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(feedUploadProvider).content;
    final contentController = useTextEditingController(text: ref.watch(feedUploadProvider).content);

    useEffect(() {
      if (contentController.text != content) {
        contentController.text = content;
      }

      return null;
    }, [content]);

    return TextField(
      controller: contentController,
      onChanged: (value) => ref.read(feedUploadProvider.notifier).updateContent(value),
      maxLines: null,
      maxLength: 300,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: "내용을 입력하세요",
        border: InputBorder.none,
        hintStyle: AppTypeface.body1.copyWith(height: 1.6, color: AppColor.gray500),
        counterText: '',
      ),
    );
  }
}
