import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/feed_search_sort.dart';

/// 검색 결과에 대한 정렬 유형을 선택하는 팝업을 엽니다.
Future<FeedSearchSort?> showSearchSortSelect(
  BuildContext context, {
  required LayerLink layerLink,
  required FeedSearchSort sort,
}) {
  return GdsAdaptiveSelect.show(
    context,
    layerLink: layerLink,
    position: .right,
    builder: (context) {
      return .new(
        title: '정렬',
        index: FeedSearchSort.values.indexOf(sort),
        items: FeedSearchSort.values.builder((value) {
          return (
            label: value.displayName,
            onTap: () => context.pop(value),
          );
        }),
      );
    },
  );
}
