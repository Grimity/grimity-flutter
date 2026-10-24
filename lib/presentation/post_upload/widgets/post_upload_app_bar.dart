import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_type.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';
import 'package:grimity/presentation/post_upload/views/show_post_upload_type_select.dart';
import 'package:pervice/pervice.dart';

/// 글 유형 선택과 작성 및 수정 액션을 표시하는 앱바.
class PostUploadAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.initialPost,
    required this.canSubmit,
    required this.title,
    required this.content,
  });

  /// 수정 시 초기값으로 사용할 기존 글.
  final PostDetailResponse? initialPost;

  /// 글을 제출할 수 있는지 여부.
  final bool canSubmit;

  /// 제출할 글의 제목.
  final String title;

  /// 제출할 글의 HTML 본문.
  final String content;

  /// 기존 글을 수정하는 모드인지 여부.
  bool get isEdit => initialPost != null;

  @override
  Widget build(BuildContext context) {
    // 현재 선택한 글 유형과 제출 버튼의 로딩 상태 관리.
    final postType = context.stateOf(() => initialPost?.type ?? .normal);
    final loading = context.stateOf(() => false);

    return GdsTopNavigation.editor(
      onBack: context.pop,
      onTitle: () async {
        final newPostType = await showPostUploadTypeSelect(context, postType.value);

        // 사용자가 게시글 유형을 선택한 경우 이를 반영.
        if (newPostType != null) {
          postType.value = newPostType;
        }
      },
      action: .new(
        label: isEdit ? '수정' : '업로드',
        onTap: () => loading.run(() => submit(context, postType.value)),
        status: .from(enabled: canSubmit),
      ),
      title: postType.value.displayName,
    );
  }

  /// 제목과 HTML 본문으로 글을 생성하거나 수정합니다.
  Future<void> submit(BuildContext context, PostType type) async {
    final request = CreatePostRequest(
      title: title,
      content: content,
      type: type,
    );

    if (isEdit) {
      await PutPostsById(id: initialPost!.id, request: request).request();

      // 현재 페이지를 닫고 완료 안내 표시.
      if (context.mounted) {
        context.pop(true);

        GdsToast.show('글을 수정했어요', status: .positive);
      }
    } else {
      final response = await PostPosts(request: request).request();

      // 상세 페이지로 이동하고 완료 안내 표시.
      if (context.mounted) {
        context.pushReplacement(PostDetailPage(id: response.id));

        GdsToast.show('글을 업로드했어요', status: .positive);
      }
    }
  }
}
