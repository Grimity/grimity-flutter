import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/user_feeds_sort.dart';
import 'package:grimity/extensions/model/user_profile_response.dart';
import 'package:grimity/presentation/feed_upload/pages/feed_upload_page.dart';
import 'package:grimity/presentation/profile/views/show_user_feeds_sort_select.dart';
import 'package:grimity/presentation/profile/widgets/profile_content_toolbar.dart';
import 'package:grimity/widgets/sliver_feeds.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 프로필 화면에서 사용자의 그림을 조회하고 이를 표시하는 위젯.
class ProfileFeeds extends StatelessWidget with GdsTabView {
  const new({
    super.key,
    required this.data,
  });

  final UserProfileResponse data;

  @override
  String get label => '그림';

  @override
  int get count => data.feedCount.toInt();

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

  /// 사용자의 피드 목록을 불러오는 서비스를 생성합니다.
  LoadMoreService<UserFeedsResponse> createService(
    UserFeedsSort sort,
    AlbumWithCountResponse? album,
  ) {
    return .new(
      builder: (cursor) => GetUsersByIdFeeds(
        id: data.id,
        cursor: cursor,
        sort: sort,
        albumId: album?.id,
      ),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sort = context.stateOf<UserFeedsSort>(() => .latest);
    final album = context.stateOf<AlbumWithCountResponse?>(() => null);

    // 정렬 기준과 앨범 선택별로 서비스 관리.
    final service = context.serviceOf(
      () => createService(sort.value, album.value),
      key: ValueKey((sort.value, album.value)),
    );

    // 앨범 편집 페이지로 이동하는 액션 버튼.
    final albumEditAction = GdsIconButtonAction(
      icon: .folderEdit,
      onTap: () {}, // TODO
    );

    return GdsInfiniteScroll(
      onLoadMore: service.loadMore,
      enabled: service.canLoreMore,
      child: SliverScrollView(
        padding: context.whenDevice(
          mobile: 16.all,
          tablet: 20.all,
        ),
        slivers: [
          // 앨범 카테고리 목록 표시
          SliverToBoxAdapter(
            child: GdsCategory(
              index: album.value == null ? 0 : data.albums.indexOf(album.value!) + 1,
              action: data.isMe ? albumEditAction : null,
              items: [
                .new(label: '전체'),

                // 앨범별 피드 개수 표시.
                ...data.albums.builder((value) {
                  return .new(
                    label: value.name,
                    count: value.feedCount.toInt(),
                  );
                }),
              ],
              onChanged: (index) {
                if (index == 0) {
                  album.value = null;
                } else {
                  album.value = data.albums[index - 1];
                }
              },
            ),
          ),
          SliverGap(
            context.whenDevice(
              mobile: 8,
              tablet: 16,
            ),
          ),

          // 피드 개수와 정렬 버튼 표시
          service.sliver(
            placeholder: placeholder,
            builder: (data) {
              final feeds = data.expand((e) => e.feeds).toList();

              return SliverToBoxAdapter(
                child: ProfileContentToolbar(
                  count: count,
                  filterBuilder: (context, layerLink) {
                    return GdsFilter(
                      variant: .text,
                      enabled: feeds.isNotEmpty,
                      label: sort.value.displayName,
                      onTap: () async {
                        final newSort = await showUserFeedsSortSelect(context, layerLink: layerLink, sort: sort.value);

                        // 정렬 기준을 선택한 경우 이를 반영.
                        if (newSort != null) {
                          sort.value = newSort;
                        }
                      },
                    );
                  },
                  actions: [
                    if (this.data.isMe) ...[
                      .new(
                        leadingIcon: .sortHorizontal,
                        enabled: feeds.isNotEmpty,
                        label: '그림 정리',
                        onTap: () {}, // TODO
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          SliverGap(
            context.whenDevice(
              mobile: 8,
              tablet: 12,
            ),
          ),

          // 피드 목록 표시
          service.sliver(
            placeholder: placeholder,
            builder: (data) {
              final feeds = data.expand((e) => e.feeds).toList();

              // 보여줄 수 있는 피드가 아예 없을 경우.
              if (feeds.isEmpty) {
                return SliverToBoxAdapter(
                  child: _EmptyState(isMe: this.data.isMe),
                );
              }

              return SliverFeeds(
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  final feed = feeds[index];

                  return (
                    id: feed.id,
                    thumbnail: feed.thumbnail,
                    title: feed.title,
                    nickname: this.data.name,
                    likeCount: feed.likeCount.toInt(),
                    viewCount: feed.viewCount.toInt(),
                    isLike: feed.isLike,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 프로필에 표시할 피드가 없을 때 표시하는 위젯.
class _EmptyState extends StatelessWidget {
  const new({required this.isMe});

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return GdsEmptyState(
        illust: .illust,
        title: '첫 그림을 업로드해보세요',
        action: .new(
          type: .solid,
          label: '그림 업로드',
          onTap: () {
            // 피드 업로드 페이지로 이동.
            context.push(const FeedUploadPage());
          },
        ),
      );
    }

    return GdsEmptyState(
      illust: .resultNull,
      title: '업로드한 그림이 없어요',
    );
  }
}
