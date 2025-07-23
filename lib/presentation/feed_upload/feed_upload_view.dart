import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/widget/grimity_lottie_loading.dart';
import 'package:grimity/presentation/common/widget/grimity_pop_scope.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_cancel_dialog.dart';

class FeedUploadView extends ConsumerWidget {
  const FeedUploadView({
    super.key,
    required this.feedUploadAppBar,
    required this.feedUploadBodyView,
    required this.feedUploadScaffoldBottomSheet,
    required this.bottomSheetHeight,
    required this.from,
  });

  final PreferredSizeWidget feedUploadAppBar;
  final Widget feedUploadBodyView;
  final Widget feedUploadScaffoldBottomSheet;
  final double bottomSheetHeight;
  final String from;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottomSheetHeight = 42;
    final uploading = ref.watch(feedUploadProvider).uploading;

    return GrimityPopScope(
      canPop: false,
      callback:
          uploading
              ? () {
                ToastService.showError('그림 업로드가 진행중 입니다.');
              }
              : () {
                showCancelFeedUploadDialog(context, from);
              },
      child: Stack(
        children: [
          Container(
            color: AppColor.gray00,
            child: SafeArea(
              top: false,
              child: Scaffold(
                appBar: feedUploadAppBar,
                body: Padding(padding: EdgeInsets.only(bottom: bottomSheetHeight), child: feedUploadBodyView),
                bottomSheet: feedUploadScaffoldBottomSheet,
              ),
            ),
          ),
          if (uploading) GrimityLottieLoadingWidget(),
        ],
      ),
    );
  }
}
