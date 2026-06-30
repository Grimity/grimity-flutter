import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/search/provider/search_feed_sort_type_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchTabBar extends ConsumerWidget {
  const SearchTabBar({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortType = ref.watch(searchFeedSortTypeProvider);
    final keyword = ref.watch(searchKeywordProvider);
    final colors = context.gdsColors;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border.graySubtle)),
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return Row(
            children: [
              Expanded(
                child: GdsTab(
                  size: context.isMobile ? GdsTabSize.sm : GdsTabSize.md,
                  showBorder: false,
                  controller: controller,
                  items: [
                    GdsTabItem(label: '그림', onTap: () => controller.animateTo(0)),
                    GdsTabItem(label: '유저', onTap: () => controller.animateTo(1)),
                    GdsTabItem(label: '자유게시판', onTap: () => controller.animateTo(2)),
                  ],
                ),
              ),
              GdsMenuAnchor(
                builder: (link) {
                  return GdsFilter(
                    type: GdsFilterType.text,
                    text: sortType.displayName,
                    enabled: keyword.isNotEmpty,
                    onTap: () => _showSortTypeMenu(context, ref, link),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _showSortTypeMenu(
    BuildContext context,
    WidgetRef ref,
    LayerLink link,
  ) {
    final sortType = ref.read(searchFeedSortTypeProvider);

    final popup = GrimityMenuPopup(
      title: '정렬',
      layerLink: link,
      isOption: true,
      items: [
        ...SortType.searchFeedSortValues.map((type) {
          return GdsMenuItem(
            label: type.displayName,
            state: sortType == type ? GdsListItemState.pressed : GdsListItemState.enabled,
            onTap: () {
              context.pop();
              ref.read(searchFeedSortTypeProvider.notifier).update(type);
            },
          );
        }),
      ],
    );

    return popup.show(context, GdsMenuPosition.right);
  }
}
