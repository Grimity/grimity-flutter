import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_underline_text_field.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadTitleTextField extends HookConsumerWidget {
  const PostUploadTitleTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(postUploadProvider).title;
    final controller = useTextEditingController(text: title);

    useEffect(() {
      if (controller.text != title) {
        controller.text = title;
      }

      return null;
    }, [title]);

    return GrimityUnderlineTextField.normal(
      controller: controller,
      onChanged: (value) => ref.read(postUploadProvider.notifier).updateTitle(value),
      hintText: '제목을 입력하세요',
      useBodyTextStyle: true,
      maxLength: 32,
    );
  }
}
