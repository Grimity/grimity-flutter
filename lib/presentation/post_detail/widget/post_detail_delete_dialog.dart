import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';

void showDeletePostDialog(String postId, BuildContext context, WidgetRef ref) {
  final router = AppRouter.router(ref);

  showDialog(
    context: context,
    builder:
        (dialogContext) => GrimityDialog(
          title: '게시글을 삭제할까요?',
          content: '삭제 이후 되돌릴 수 없어요',
          cancelText: '취소',
          confirmText: '삭제',
          onCancel: () => dialogContext.pop(),
          onConfirm: () async {
            dialogContext.pop();
            final result = await ref.read(postDetailDataProvider(postId).notifier).deletePost(postId);

            // 삭제가 성공한 경우 Pop
            if (result) router.pop();
          },
        ),
  );
}
