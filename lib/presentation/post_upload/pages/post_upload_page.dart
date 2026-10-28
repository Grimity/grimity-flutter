import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_image.dart';
import 'package:grimity/presentation/gallery/pages/gallery_page.dart';
import 'package:grimity/presentation/post_upload/models/post_upload_model.dart';
import 'package:grimity/presentation/post_upload/widgets/post_upload_app_bar.dart';
import 'package:grimity/presentation/post_upload/views/show_post_upload_exit_alert.dart';
import 'package:grimity/presentation/post_upload/views/show_post_upload_link_modal.dart';
import 'package:pervice/pervice.dart';

/// 게시글을 작성하거나 기존 게시글을 수정하는 페이지.
class PostUploadPage extends StatelessWidget {
  const new({
    super.key,
    this.initialPost,
  });

  /// 수정 시 초기값으로 사용할 기존 게시글.
  final PostDetailResponse? initialPost;

  /// 게시글 작성 시 선택할 수 있는 유형 목록.
  static const postTypes = <PostType>[
    .normal,
    .question,
    .feedback,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.useQuillController();
    final model = context.stateOf(() {
      // 기존 HTML 본문을 편집 가능한 Quill 문서로 변환.
      if (initialPost != null) {
        controller.loadHtml(initialPost!.content);
      }

      return PostUploadModel.from(
        initialPost,
        content: controller.toHtml(),
        hasText: controller.hasText,
      );
    });

    context.onInitState(() {
      // 커서 이동은 제외하고 본문이 변경되었을 때 모델에 반영.
      void updateContent() {
        final updated = model.value.copyWith(
          content: controller.toHtml(),
          hasText: controller.hasText,
        );

        if (updated.different(model.value)) {
          model.value = updated;
        }
      }

      controller.addListener(updateContent);
      context.onDispose(() => controller.removeListener(updateContent));
    });

    final data = model.value;

    return PopScope(
      canPop: !data.hasChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 작성 취소 확인 팝업 표시.
        showPostUploadExitAlert(context);
      },
      child: GdsScaffold(
        appBar: PostUploadAppBar(
          initialPost: initialPost,
          model: model,
        ),
        body: GdsEditor(
          controller: controller,
          onAddImage: () => onAddImage(context),
          onAddLink: () => showPostUploadLinkModal(context),
          maxCount: 500,
          padding: .only(top: 24, bottom: 8, left: 20, right: 20),
          header: GdsTextField.title(
            size: .sm,
            maxLength: 32,
            onChanged: (title) {
              model.value = data.copyWith(title: title);
            },
            initialText: data.title,
            placeholder: '제목을 입력해주세요',
          ),
        ),
      ),
    );
  }

  /// 갤러리에서 이미지를 선택하고 업로드한 이미지의 저장 경로를 반환합니다.
  Future<List<String>?> onAddImage(BuildContext context) async {
    final images = await context.push<List<ImageProvider>>(
      const GalleryPage(),
    );

    // 사용자가 이미지 선택을 취소했을 경우.
    if (images == null || images.isEmpty) {
      return null;
    }

    return (await AppImage.resolve(images, .post)).urls;
  }
}
