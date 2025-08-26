import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/photo_select/photo_select_view.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_page_argument_provider.dart';
import 'package:grimity/presentation/photo_select/view/photo_select_body_view.dart';
import 'package:grimity/presentation/photo_select/widget/photo_select_app_bar.dart';

class PhotoSelectPage extends StatelessWidget {
  const PhotoSelectPage({super.key, required this.type});

  final UploadImageType type;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [photoSelectTypeArgumentProvider.overrideWithValue(type)],
      child: PhotoSelectView(photoSelectAppBar: PhotoSelectAppBar(), photoSelectBodyView: PhotoSelectBodyView()),
    );
  }
}
