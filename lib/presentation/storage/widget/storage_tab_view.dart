import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/storage/enum/storage_type.dart';

class StorageTabView extends StatelessWidget {
  const StorageTabView({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: GdsTab(
        size: context.isMobile ? GdsTabSize.sm : GdsTabSize.lg,
        controller: controller,
        items: [
          ...StorageType.values.mapIndexed((index, type) {
            return GdsTabItem(
              label: type.label,
              onTap: () => controller.animateTo(index),
            );
          }),
        ],
      ),
    );
  }
}
