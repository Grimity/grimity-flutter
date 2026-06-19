import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/view/feed_upload_album_view.dart';
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
    return ListView(
      padding:
          context.isMobile ? EdgeInsets.only(top: GdsSpacing.spacing8) : EdgeInsets.only(top: GdsSpacing.spacing20),
      children: [
        Center(
          child:
              ref.watch(feedUploadProvider).images.isNotEmpty
                  ? FeedUploadSelectedImageView()
                  : FeedUploadAddImageButton(),
        ),
        Gap(context.isMobile ? GdsSpacing.spacing12 : GdsSpacing.spacing32),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: context.isMobile ? GdsSpacing.spacing12 : GdsSpacing.spacing20,
            children: [
              FeedUploadTitleTextField(),
              FeedUploadContentTextField(),
              FeedUploadTagView(),
              FeedUploadAlbumView(),
            ],
          ),
        ),
      ],
    );
  }
}
