import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:gds/gds.dart';
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
    final focusNode = useFocusNode();
    final notifier = ref.read(postUploadProvider.notifier);
    final colors = context.gdsColors;
    final selectionColor = colors.status.info.withOpacity(0.5);

    useEffect(() {
      void listener() {
        notifier.replaceContentDelta(quillController.document.toDelta());
      }

      quillController.addListener(listener);
      return () => quillController.removeListener(listener);
    }, [quillController]);

    return Padding(
      padding: EdgeInsets.only(
        top: GdsSpacing.spacing16,
        bottom: GdsSpacing.spacing12,
      ),
      child: DefaultTextStyle.merge(
        style: GdsTypography.label2.copyWith(color: colors.text.grayBold),
        child: QuillEditor(
          focusNode: focusNode,
          scrollController: scrollController,
          controller: quillController,
          config: QuillEditorConfig(
            placeholder: '내용을 입력해주세요',
            scrollable: false,
            customStyles: AppTypefaceEditor(context: context).defaultStyles,
            embedBuilders: [
              DeletableImageBuilder(),
              ...FlutterQuillEmbeds.editorBuilders(),
            ],
            textSelectionThemeData: TextSelectionThemeData(
              selectionColor: selectionColor,
              cursorColor: colors.status.info,
              selectionHandleColor: colors.status.info,
            ),
          ),
        ),
      ),
    );
  }
}
