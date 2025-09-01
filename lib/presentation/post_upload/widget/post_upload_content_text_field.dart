import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:grimity/app/config/app_typeface_editor.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_deletable_image_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadContentTextField extends HookConsumerWidget {
  const PostUploadContentTextField({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quillController = ref.watch(postUploadQuillControllerArgumentProvider);
    final notifier = ref.read(postUploadProvider.notifier);
    final focusNode = useFocusNode();

    useEffect(() {
      void listener() {
        notifier.replaceContentDelta(quillController.document.toDelta());
      }

      quillController.addListener(listener);
      return () => quillController.removeListener(listener);
    }, [quillController]);

    return DefaultTextStyle.merge(
      style: AppTypefaceEditor.editorFontFamily,
      child: QuillEditor(
        focusNode: focusNode,
        scrollController: scrollController,
        controller: quillController,
        config: QuillEditorConfig(
          placeholder: '내용을 입력하세요',
          scrollable: false,
          scrollBottomInset: MediaQuery.of(context).viewInsets.bottom + 12,
          customStyles: AppTypefaceEditor.quillDefaultStyles,
          embedBuilders: [DeletableImageBuilder(), ...FlutterQuillEmbeds.editorBuilders()],
        ),
      ),
    );
  }
}
