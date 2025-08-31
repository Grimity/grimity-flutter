import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/layout/grimity_uploading_layout.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadView extends ConsumerWidget {
  const PostUploadView({
    super.key,
    required this.postUploadAppBar,
    required this.postUploadBodyView,
    required this.postUploadBottomSheet,
    required this.bottomSheetHeight,
  });

  final PreferredSizeWidget postUploadAppBar;
  final Widget postUploadBodyView;
  final Widget postUploadBottomSheet;
  final double bottomSheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postUploadProvider);
    final uploading = state.uploading;

    final child = Container(
      color: AppColor.gray00,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: postUploadAppBar,
          body: Padding(padding: EdgeInsets.only(bottom: bottomSheetHeight), child: postUploadBodyView),
          bottomSheet: postUploadBottomSheet,
        ),
      ),
    );

    return GrimityUploadingLayout(uploading: uploading, child: child);
  }
}
