import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/chat_new/provider/new_chat_provider.dart';
import 'package:grimity/presentation/chat_new/view/new_chat_search_bar.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewChatView extends ConsumerWidget {
  const NewChatView({
    super.key,
    required this.isModal,
  });

  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(context.isTablet ? isModal : !isModal);
    final data = ref.watch(newChatProviderProvider);

    // 현재 데이터를 불러오고 있는 경우.
    if (data.isLoading) {
      return Center(child: GdsCircularLoading());
    }

    late final Widget child;
    final NewChatState state = data.value!;

    // 현재 팔로잉하고 있는 사용자가 아예 없는 경우.
    if (state.followings.isEmpty) {
      if (state.keyword == null) {
        child = SingleChildScrollView(
          child: GdsEmptyState(
            icon: GdsIcon.user,
            title: "팔로우 하는 작가가 없어요",
            description: "관심 있는 작가를 팔로우하고\n메세지를 주고받아 보세요",
          ),
        );
      } else {
        child = SingleChildScrollView(
          child: GdsEmptyState(
            icon: GdsIcon.warning,
            title: "일치하는 작가가 없어요",
            description: "검색어의 단어 수를 줄이거나\n다른 검색어로 검색해보세요.",
          ),
        );
      }
    } else {
      child = GrimityInfiniteScrollPagination(
        isEnabled: data.value!.nextCursor != null,
        onLoadMore: ref.read(newChatProviderProvider.notifier).loadMore,
        child: ListView.builder(
          padding:
              isModal
                  ? EdgeInsets.all(GdsSpacing.spacing20).add(EdgeInsets.only(top: GdsSpacing.spacing12))
                  : EdgeInsets.all(GdsSpacing.spacing16),
          itemCount: data.value!.followings.length,
          itemBuilder: (context, index) {
            final model = data.value!.followings[index];

            return GdsGesture(
              onTap: () => ref.read(newChatProviderProvider.notifier).submit(context, model),
              child: GdsUserItem.iconId(
                userId: '@${model.url}',
                nickName: model.name,
                personAvatar: GdsPersonAvatar(imageUrl: model.image),
              ),
            );
          },
        ),
      );
    }

    return Column(
      children: [
        NewChatSearchBar(
          enabled: state.followings.isNotEmpty || state.keyword != null,
          isModal: isModal,
        ),
        Expanded(child: child),
      ],
    );
  }
}
