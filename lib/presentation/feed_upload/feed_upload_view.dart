import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/layout/grimity_uploading_layout.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';

class FeedUploadView extends ConsumerWidget {
  const FeedUploadView({
    super.key,
    required this.feedUploadAppBar,
    required this.feedUploadBodyView,
  });

  final Widget feedUploadAppBar;
  final Widget feedUploadBodyView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploading = ref.watch(feedUploadProvider).uploading;

    final child = GdsScaffold(
      appBar: feedUploadAppBar,
      body: feedUploadBodyView,
    );

    return GrimityUploadingLayout(
      title: '이미지를 업로드 중이에요',
      description: '이미지 업로드 도중 화면을 닫거나\n뒤로가면 업로드가 중단될 수 있어요',
      uploading: uploading,
      child: child,
    );
  }
}
