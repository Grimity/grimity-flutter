import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/feed_search_sort.dart';

///
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
