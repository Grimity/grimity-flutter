// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_search_by.dart';
import 'package:grimity/presentation/board/views/show_search_by_select.dart';
import 'package:pervice/pervice.dart';

/// 게시글 검색 필터와 검색어 입력을 제공하는 위젯.
class BoardSearch extends StatelessWidget {
  const new({
    super.key,
    required this.searchBy,
    required this.keyword,
  });

  final ValueState<PostSearchBy> searchBy;
  final ValueState<String> keyword;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        // 필터 버튼 표시
        GdsPopoverAnchor.builder(
          builder: (context, layerLink) {
            return GdsFilter(
              variant: .outline,
              label: searchBy.value.displayName,
              onTap: () async {
                final newSearchBy = await showSearchBySelect(
                  context,
                  layerLink,
                  searchBy.value,
                );

                // 사용자가 검색 기준을 수정한 경우 이를 반영.
                if (newSearchBy != null) {
                  searchBy.value = newSearchBy;
                }
              },
            );
          },
        ),

        // 검색 바 표시
        Flexible(
          child: GdsTextField.search(
            size: .sm,
            onSubmitted: keyword.setter,
            placeholder: '검색어를 입력하세요',
          ),
        ),
      ],
    );
  }
}
