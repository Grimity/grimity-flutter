import 'package:flutter/material.dart';

class PhotoSelectView extends StatelessWidget {
  final PreferredSizeWidget photoSelectAppBar;
  final Widget photoSelectBodyView;

  const PhotoSelectView({super.key, required this.photoSelectAppBar, required this.photoSelectBodyView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: photoSelectAppBar, body: photoSelectBodyView);
  }
}
