import 'package:flutter/material.dart';

class StorageView extends StatelessWidget {
  final PreferredSizeWidget storageAppBar;
  final Widget storageBodyView;

  const StorageView({super.key, required this.storageAppBar, required this.storageBodyView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: storageAppBar, body: storageBodyView);
  }
}
