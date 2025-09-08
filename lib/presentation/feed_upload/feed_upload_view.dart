import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/layout/grimity_uploading_layout.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';

class FeedUploadView extends ConsumerWidget {
  const FeedUploadView({
    super.key,
    required this.feedUploadAppBar,
    required this.feedUploadBodyView,
    required this.feedUploadScaffoldBottomSheet,
    required this.bottomSheetHeight,
  });

  final PreferredSizeWidget feedUploadAppBar;
  final Widget feedUploadBodyView;
  final Widget feedUploadScaffoldBottomSheet;
  final double bottomSheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploading = ref.watch(feedUploadProvider).uploading;

    final child = Container(
      color: AppColor.gray00,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: feedUploadAppBar,
          body: Padding(padding: EdgeInsets.only(bottom: bottomSheetHeight), child: feedUploadBodyView),
          bottomSheet: feedUploadScaffoldBottomSheet,
        ),
      ),
    );

    return GrimityUploadingLayout(uploading: uploading, child: child);
  }
}
