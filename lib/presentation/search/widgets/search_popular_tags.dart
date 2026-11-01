// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

/// 검색 화면에서 인기 태그를 가로 목록으로 표시하는 위젯.
class SearchPopularTags extends StatelessWidget {
  const new({super.key});

  /// 인기 태그를 불러오는 동안 표시할 임시 데이터.
  static final placeholder = List.generate(15, (_) {
    return PopularTagResponse(
      tagName: 'ABCDEF',
      thumbnail: '',
    );
  });

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GetTagsPopular.new);

    // SHARED STATE
    final keyword = context.sharedStateFor<String>(
      key: const ValueKey('search-keyword'),
    );

    // 가로 스크롤 태그 목록.
    final child = service.builder(
      placeholder: placeholder,
      builder: (data) {
        return GdsMasking(
          child: HorizontalListView.separated(
            separatorBuilder: (_, _) => const Gap(8),
            clipBehavior: .none,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final tag = data[index];

              return GdsTag(
                size: context.whenDevice(
                  mobile: .xs,
                  tablet: .md,
                ),
                label: tag.tagName,
                onTap: () => keyword.value = tag.tagName,
              );
            },
          ),
        );
      },
    );

    if (context.isMobile) {
      return Padding(
        padding: .only(top: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          spacing: 6,
          children: [
            GdsText(
              '추천 태그',
              color: .textGrayBold,
              style: .label5,
            ),

            // 태그 목록 표시
            child,
          ],
        ),
      );
    }

    return Padding(
      padding: .symmetric(vertical: 16, horizontal: 20),
      child: Row(
        spacing: 20,
        children: [
          GdsText(
            '추천 태그',
            color: .textGrayBold,
            style: .subtitle2,
          ),

          // 태그 목록 표시
          Expanded(child: child),
        ],
      ),
    );
  }
}
