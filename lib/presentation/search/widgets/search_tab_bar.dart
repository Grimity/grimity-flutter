import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/feed_search_sort.dart';
import 'package:grimity/presentation/search/pages/search_page.dart';
import 'package:grimity/presentation/search/views/show_search_sort_select.dart';
import 'package:pervice/extensions/value_notifier_extension.dart';

/// 검색 결과 유형별 탭과 정렬 필터를 표시하는 위젯.
class SearchTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    required this.keyword,
    required this.sort,
  });

  final TabController controller;
  final ValueState<String> keyword;
  final ValueState<FeedSearchSort> sort;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.whenDevice(
        mobile: .only(top: 16, left: 16, right: 16),
        tablet: .only(top: 20, left: 20, right: 20),
      ),
      child: GdsTabBar(
        controller: controller,
        items: SearchPage.views.items,

        // 유형 필터 표시
        trailing: GdsPopoverAnchor.builder(
          builder: (context, layerLink) {
            return GdsFilter(
              variant: .text,
              enabled: keyword.value.isNotEmpty,
              label: sort.value.displayName,
              onTap: () async {
                final newSort = await showSearchSortSelect(
                  context,
                  layerLink: layerLink,
                  sort: sort.value,
                );

                // 정렬 기준을 선택한 경우 이를 반영.
                if (newSort != null) {
                  sort.value = newSort;
                }
              },
            );
          },
        ),
      ),
    );
  }
}
