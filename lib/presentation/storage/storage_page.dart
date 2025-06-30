import 'package:flutter/material.dart';
import 'package:grimity/presentation/storage/storage_view.dart';
import 'package:grimity/presentation/storage/view/storage_body_view.dart';
import 'package:grimity/presentation/storage/widget/storage_app_bar.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageView(storageAppBar: StorageAppBar(), storageBodyView: StorageBodyView());
  }
}
