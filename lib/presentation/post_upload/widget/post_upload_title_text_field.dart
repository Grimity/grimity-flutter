import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
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

    return GdsTextField.title(
      size: GdsTextFieldSize.small,
      placeholder: '제목을 입력해주세요',
      maxLength: 32,
      onChanged: ref.read(postUploadProvider.notifier).updateTitle,
    );
  }
}
