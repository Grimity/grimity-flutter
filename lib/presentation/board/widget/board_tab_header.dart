import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';

class BoardTabHeader extends StatelessWidget {
  const BoardTabHeader({
    super.key,
    required this.tabController,
    required this.types,
  });

  final TabController tabController;

  /// 탭에 표시할 게시글 타입 리스트
  final List<PostType> types;

  @override
  Widget build(BuildContext context) {
    void onTap(PostType type) {
      final index = types.indexOf(type);
      if (index != tabController.index) {
        tabController.animateTo(index);
      }
    }

    return GdsTab(
      size: context.isMobile ? GdsTabSize.sm : GdsTabSize.md,
      items: types.map((type) => GdsTabItem(label: type.displayName, onTap: () => onTap(type))).toList(),
      controller: tabController,
      showBorder: context.isMobile,
    );
  }
}
