import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/storage/widget/storage_empty_widget.dart';

class StorageEmptyView extends StatelessWidget {
  final double topPadding;

  const StorageEmptyView({super.key, this.topPadding = 80});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Gap(topPadding.h), Center(child: StorageEmptyWidget())]);
  }
}
