// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_type.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';
import 'package:grimity/presentation/post_upload/models/post_upload_model.dart';
import 'package:grimity/presentation/post_upload/views/show_post_upload_type_select.dart';
import 'package:pervice/pervice.dart';

/// 글 유형 선택과 작성 및 수정 액션을 표시하는 앱바.
class PostUploadAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.initialPost,
    required this.model,
  });

  /// 수정 시 초기값으로 사용할 기존 글.
  final PostDetailResponse? initialPost;

  /// 제목, 본문과 게시글 유형을 관리하는 입력 상태.
  final ValueState<PostUploadModel> model;

  /// 기존 글을 수정하는 모드인지 여부.
  bool get isEdit => initialPost != null;

  @override
  Widget build(BuildContext context) {
    final data = model.value;

    return GdsTopNavigation.editor(
      onBack: () => Navigator.of(context).maybePop(),
      onTitle: () async {
        final newPostType = await showPostUploadTypeSelect(context, data.type);

        // 사용자가 게시글 유형을 선택한 경우 이를 반영.
        if (context.mounted && newPostType != null) {
          model.value = data.copyWith(type: newPostType);
        }
      },
      action: .new(
        label: isEdit ? '수정' : '업로드',
        onTap: () => submit(context, data),
        enabled: data.canSubmit,
      ),
      title: data.type.displayName,
    );
  }

  /// 제목과 HTML 본문으로 글을 생성하거나 수정합니다.
  Future<void> submit(BuildContext context, PostUploadModel model) async {
    final request = CreatePostRequest(
      title: model.title,
      content: model.content,
      type: model.type,
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
