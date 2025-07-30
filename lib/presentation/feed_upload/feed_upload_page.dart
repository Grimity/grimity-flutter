import 'package:flutter/material.dart';
import 'package:grimity/presentation/feed_upload/feed_upload_view.dart';
import 'package:grimity/presentation/feed_upload/view/feed_upload_body_view.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_app_bar.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_scaffold_bottom_sheet.dart';

class FeedUploadPage extends StatelessWidget {
  const FeedUploadPage({super.key});

  final double bottomSheetHeight = 42;

  @override
  Widget build(BuildContext context) {
    return FeedUploadView(
      feedUploadAppBar: FeedUploadAppBar(),
      feedUploadBodyView: FeedUploadBodyView(),
      feedUploadScaffoldBottomSheet: FeedUploadScaffoldBottomSheet(height: bottomSheetHeight),
      bottomSheetHeight: bottomSheetHeight,
    );
  }
}
