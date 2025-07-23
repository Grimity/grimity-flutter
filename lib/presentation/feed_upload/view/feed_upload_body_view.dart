import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/view/feed_upload_selected_image_view.dart';
import 'package:grimity/presentation/feed_upload/view/feed_upload_tag_view.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_add_image_button.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_content_text_field.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_title_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadBodyView extends HookConsumerWidget {
  const FeedUploadBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: FeedUploadTitleTextField()),
          Gap(16),
          ref.watch(feedUploadProvider).images.isNotEmpty ? FeedUploadSelectedImageView() : FeedUploadAddImageButton(),
          Gap(8),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: FeedUploadTagView()),
          Gap(8),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: FeedUploadContentTextField()),
        ],
      ),
    );
  }
}
