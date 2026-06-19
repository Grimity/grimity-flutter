import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';

class FeedUploadAddImageButton extends StatelessWidget {
  const FeedUploadAddImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsAlbumCard(
      type: GdsAlbumCardType.imageUpload,
      title: 'ㅤ',
      onTap: () => PhotoSelectRoute(type: UploadImageType.feed).push(context),
    );
  }
}
