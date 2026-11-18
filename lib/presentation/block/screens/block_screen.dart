// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/block/widgets/block_user_item.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:pervice/pervice.dart';

/// 차단한 작가 목록을 조회하고 이를 표시하는 화면.
class BlockScreen extends GdsBasicScreen {
  const new();

  /// 차단 목록을 불러오는 동안 표시할 임시 사용자 데이터.
  static final placeholder = MyBlockingsResponse(
    users: List.generate(10, (_) {
      return const .new(
        id: '',
        name: 'Placeholder',
        image: '',
        url: '',
      );
    }),
  );

  @override
  String get title => '차단';

  @override
  bool get scroll => false;

  @override
  GdsBasicContent build(BuildContext context) {
    final service = context.serviceOf(GetMeBlockings.new);

    return .new(
      appBar: AppTopNavigation.title(),
      child: service.builder(
        placeholder: placeholder,
        builder: (data) {
          final users = data.users;

          // 차단한 작가가 아예 없을 경우.
          if (users.isEmpty) {
            return GdsEmptyState(
              illust: .warning,
              title: '차단한 작가가 없어요',
            );
          }

          return ListView.builder(
            padding: scrollPaddingOf(context),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return BlockUserItem(
                nickname: user.name,
                image: user.image?.toImage(),
                id: user.id,
                url: user.url,
                isBlocking: true,
              );
            },
          );
        },
      ),
    );
  }
}
