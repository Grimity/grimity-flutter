import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/layout/grimity_uploading_layout.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadView extends ConsumerWidget {
  const PostUploadView({
    super.key,
    required this.postUploadAppBar,
    required this.postUploadBodyView,
  });

  final Widget postUploadAppBar;
  final Widget postUploadBodyView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postUploadProvider);
    final uploading = state.uploading;

    return GrimityUploadingLayout(
      uploading: uploading,
      title: '게시글을 업로드 중이에요',
      description: '게시글 업로드 도중 화면을 닫거나\n뒤로가면 업로드가 중단될 수 있어요',
      child: GdsScaffold(
        appBar: postUploadAppBar,
        body: postUploadBodyView,
      ),
    );
  }
}
