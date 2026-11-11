// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/album_organize/models/album_organize_model.dart';
import 'package:pervice/pervice.dart';

/// 앨범의 그림 목록을 표시하고 선택 기능을 제공하는 위젯.
class AlbumOrganizeAlbums extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<AlbumOrganizeModel> model;

  /// 피드를 불러오는 동안 표시할 임시 피드 데이터.
  static final placeholder = [
    UserFeedsResponse(
      feeds: .generate(20, (_) {
        return .new(
          id: '',
          title: 'Placeholder',
          thumbnail: '',
          likeCount: 0,
          viewCount: 0,
          cards: [],
          createdAt: .now(),
          commentCount: 0,
          isLike: false,
        );
      }),
    ),
  ];

  /// 해당 앨범의 피드를 불러오는 서비스를 생성합니다.
  LoadMoreService<UserFeedsResponse> createService() {
    return .new(
      builder: (cursor) => GetUsersByIdFeeds(
        id: profile.id,
        albumId: model.value.parent.id,
        cursor: cursor,
      ),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(
      createService,
      key: ValueKey(model.value.parent.id),
    );

    return service.sliver(
      placeholder: placeholder,
      builder: (data) {
        final hiddenIds = {
          ...model.value.removedFeeds,
          ...model.value.movedFeeds,
        };

        // 삭제하거나 이동한 그림을 목록에서 제외합니다.
        final items = data.expand((e) => e.feeds);
        final feeds = items.where((feed) => !hiddenIds.contains(feed.id)).toList();

        // 보여줄 수 있는 피드가 아예 없을 경우.
        if (feeds.isEmpty) {
          return const SliverToBoxAdapter(
            child: GdsEmptyState(
              illust: .resultNull,
              title: '업로드한 그림이 없어요',
            ),
          );
        }

        return SliverDynamicHeightGridView(
          crossAxisCount: context.feedGridCrossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: context.whenDevice(
            mobile: 24,
            tablet: 40,
          ),
          itemCount: feeds.length,
          builder: (context, index) {
            final feed = feeds[index];
            final checked = model.value.isChecked(feed);

            return GdsAlbum(
              image: feed.thumbnail.toImage(),
              title: feed.title,
              nickname: profile.name,
              likeCount: feed.likeCount.toInt(),
              viewCount: feed.viewCount.toInt(),
              checked: checked,
              onTap: () {
                // 그림을 선택하거나 해제합니다.
                if (checked) {
                  model.value.checkedFeeds.remove(feed.id);
                } else {
                  model.value.checkedFeeds.add(feed.id);
                }

                model.notifyChanged();
              },
            );
          },
        );
      },
    );
  }
}
