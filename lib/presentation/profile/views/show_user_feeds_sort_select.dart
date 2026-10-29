import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/user_feeds_sort.dart';

/// 사용자의 그림에 대한 정렬 기준을 선택하는 팝업을 엽니다.
Future<UserFeedsSort?> showUserFeedsSortSelect(
  BuildContext context, {
  required LayerLink layerLink,
  required UserFeedsSort sort,
}) {
  return GdsAdaptiveSelect.show<UserFeedsSort>(
    context,
    layerLink: layerLink,
    position: .right,
    builder: (context) {
      return .new(
        title: '정렬',
        index: UserFeedsSort.values.indexOf(sort),
        items: UserFeedsSort.values.builder((value) {
          return (
            label: value.displayName,
            onTap: () => context.pop(value),
          );
        }),
      );
    },
  );
}
