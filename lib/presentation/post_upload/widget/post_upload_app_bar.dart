import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/dialog/cancel_upload_dialog.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_select_popup.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';

class PostUploadAppBar extends ConsumerWidget {
  const PostUploadAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postUploadProvider);

    return GdsTopNavigation.editor(
      title: state.type.displayName,
      label: '업로드',
      onSave: () => _onSave(context, ref),
      onBack: () => showCancelUploadDialog(context),
      onTitle: () => _showUploadTypeSelectPopup(context, ref),
      saveEnabled: state.canUpload,
    );
  }

  void _onSave(BuildContext context, WidgetRef ref) async {
    final quillController = ref.read(postUploadQuillControllerArgumentProvider);
    final postUpload = ref.read(postUploadProvider.notifier);
    final uploadPost = await postUpload.postUpload(quillController);

    if (uploadPost != null && context.mounted) {
      PostDetailRoute(id: uploadPost.id).pushReplacement(context);
      ToastService.showSuccess('글을 업로드했어요');
    }
  }

  Future<void> _showUploadTypeSelectPopup(BuildContext context, WidgetRef ref) {
    final state = ref.read(postUploadProvider);
    final popup = GrimitySelectPopup(
      title: '말머리 선택',
      items: [
        ...PostType.uploadableTypes.map((type) {
          return GrimitySelectPopupItem(
            label: type.displayName,
            isSelected: type == state.type,
            onTap: () {
              context.pop();
              ref.read(postUploadProvider.notifier).updateType(type);
            },
          );
        }),
      ],
    );

    return popup.show(context);
  }
}
