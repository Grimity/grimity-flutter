import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

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
          GdsTabItem(label: '좋아요한 그림', onTap: () => controller.animateTo(0)),
          GdsTabItem(label: '저장한 글', onTap: () => controller.animateTo(1)),
        ],
      ),
    );
  }
}
