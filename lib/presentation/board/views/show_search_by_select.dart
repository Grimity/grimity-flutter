import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enums/post_search_by.dart';

/// 게시글 검색 기준을 선택하는 팝업을 표시합니다.
Future<PostSearchBy?> showSearchBySelect(
  BuildContext context,
  LayerLink layerLink,
  PostSearchBy selected,
) {
  final menu = GdsAdaptiveSelect(
    layerLink: layerLink,
    position: .left,
    title: '검색 필터',
    index: PostSearchBy.values.indexOf(selected),
    items: PostSearchBy.values.builder((value) {
      return (
        label: value.displayName,
        onTap: () => context.pop(value),
      );
    }),
  );

  return menu.open(context);
}
