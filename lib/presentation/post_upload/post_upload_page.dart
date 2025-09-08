import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:grimity/app/util/delta_util.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/post_upload/post_upload_view.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:grimity/presentation/post_upload/view/post_upload_body_view.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_app_bar.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/image_delete_toolbar.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/quill_bottom_sheet_toolbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadPage extends HookConsumerWidget {
  const PostUploadPage({super.key, this.postToEdit});

  final double bottomSheetHeight = 42;
  final Post? postToEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postUploadProvider);

    final quillController = useMemoized(() {
      final doc = DeltaUtil.documentFromDelta(state.contentData);
      final isEditing = state.postId != null;
      final endOffset = max(0, doc.length - 1);

      return QuillController(document: doc, selection: TextSelection.collapsed(offset: isEditing ? endOffset : 0));
    }, [state.postId]);

    useEffect(() {
      if (postToEdit != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(postUploadProvider.notifier).initializeForEdit(postToEdit!),
        );
      }
      return null;
    }, [postToEdit]);

    return ProviderScope(
      overrides: [postUploadQuillControllerArgumentProvider.overrideWithValue(quillController)],
      child: PostUploadView(
        postUploadAppBar: PostUploadAppBar(),
        postUploadBodyView: PostUploadBodyView(),
        bottomSheetHeight: bottomSheetHeight,
        postUploadBottomSheet: state.imageEdit ? ImageDeleteToolbar() : QuillBottomSheetToolbar(),
      ),
    );
  }
}
