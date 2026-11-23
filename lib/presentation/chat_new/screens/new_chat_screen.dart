import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/string_extension.dart';
import 'package:grimity/presentation/chat_new/widgets/new_chat_empty_state.dart';
import 'package:grimity/presentation/chat_new/widgets/new_chat_search_bar.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 내가 팔로잉한 작가를 검색하여 새 채팅 상대를 선택하는 화면.
class NewChatScreen extends GdsBasicScreen {
  const new();

  /// 팔로잉 목록을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = [
    MyFollowingsResponse(
      followings: .generate(10, (_) {
        return const .new(
          id: '',
          name: 'Placeholder',
          image: '',
          url: '',
          description: 'Placeholder',
        );
      }),
    ),
  ];

  @override
  String get title => '새 메시지 보내기';

  @override
  bool get scroll => false;

  @override
  EdgeInsets scrollPaddingOf(BuildContext context) {
    return .zero;
  }

  /// 검색어에 맞는 팔로잉 목록을 조회하는 서비스를 생성합니다.
  LoadMoreService<MyFollowingsResponse> createService(String keyword) {
    return .new(
      builder: (cursor) => GetMeFollowings(
        cursor: cursor,
        keyword: keyword.orNull,
      ),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  GdsBasicContent build(BuildContext context) {
    final keyword = context.stateOf(() => '');

    // 검색어를 기준으로 팔로잉 목록 서비스 관리.
    final service = context.serviceOf(
      () => createService(keyword.value),
      key: ValueKey(keyword.value),
    );

    return .new(
      appBar: AppTopNavigation.title(),
      child: Column(
        children: [
          // 검색바 표시
          NewChatSearchBar(keyword: keyword),

          // 사용자 목록 표시
          Expanded(
            child: SliverScrollView(
              // 검색바와의 상대적 거리는 모바일 16px, 테블릿 12px.
              padding: context.whenDevice(
                mobile: 8.top + 16.bottom + 16.horizontal,
                tablet: 4.top + 20.bottom + 20.horizontal,
              ),
              slivers: [
                service.sliver(
                  placeholder: placeholder,
                  builder: (data) {
                    final users = data.expand((e) => e.followings).toList();

                    // 팔로잉 목록이 비어 있으면 검색 여부에 맞는 안내 표시.
                    if (users.isEmpty) {
                      return SliverToBoxAdapter(
                        child: NewChatEmptyState(
                          keyword: keyword.value,
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return GdsUserItem.textButton(
                          nickname: user.name,
                          profile: user.image?.toImage(),
                          handle: user.url,
                          onUser: () {}, // TODO
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
