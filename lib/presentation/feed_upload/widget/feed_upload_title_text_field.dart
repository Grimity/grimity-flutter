import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadTitleTextField extends HookConsumerWidget {
  const FeedUploadTitleTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(feedUploadProvider).title;
    final controller = useTextEditingController(text: title);

    useEffect(() {
      if (controller.text != title) {
        controller.text = title;
      }

      return null;
    }, [title]);

    return GdsTextField.title(
      size: context.isMobile ? GdsTextFieldSize.small : GdsTextFieldSize.medium,
      controller: controller,
      onChanged: ref.read(feedUploadProvider.notifier).updateTitle,
      placeholder: '제목을 입력해주세요',
      maxLength: 32,
    );
  }
}
