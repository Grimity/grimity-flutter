import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/feed_upload/feed_upload_view.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/view/feed_upload_body_view.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_app_bar.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_scaffold_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadPage extends HookConsumerWidget {
  const FeedUploadPage({super.key, this.feedToEdit});

  final double bottomSheetHeight = 42;
  final Feed? feedToEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (feedToEdit != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(feedUploadProvider.notifier).initializeForEdit(feedToEdit!),
        );
      }
      return null;
    }, [feedToEdit]);

    return FeedUploadView(
      feedUploadAppBar: FeedUploadAppBar(),
      feedUploadBodyView: FeedUploadBodyView(),
      feedUploadScaffoldBottomSheet: FeedUploadScaffoldBottomSheet(height: bottomSheetHeight),
      bottomSheetHeight: bottomSheetHeight,
    );
  }
}
