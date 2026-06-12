import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class PhotoSelectView extends StatelessWidget {
  final Widget photoSelectAppBar;
  final Widget photoSelectBodyView;

  const PhotoSelectView({super.key, required this.photoSelectAppBar, required this.photoSelectBodyView});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(appBar: photoSelectAppBar, body: photoSelectBodyView);
  }
}
