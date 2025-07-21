import 'package:flutter/material.dart';
import 'package:grimity/presentation/photo_select/photo_select_view.dart';
import 'package:grimity/presentation/photo_select/view/photo_select_body_view.dart';
import 'package:grimity/presentation/photo_select/widget/photo_select_app_bar.dart';

class PhotoSelectPage extends StatelessWidget {
  const PhotoSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PhotoSelectView(photoSelectAppBar: PhotoSelectAppBar(), photoSelectBodyView: PhotoSelectBodyView());
  }
}
