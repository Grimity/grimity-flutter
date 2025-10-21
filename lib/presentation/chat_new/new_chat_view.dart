import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll_pagination/flutter_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/chat_new/provider/new_chat_provider.dart';
import 'package:grimity/presentation/chat_new/view/new_chat_scroll_item_view.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewChatView extends StatelessWidget {
  const NewChatView({
    super.key,
    required this.appBarView,
    required this.searchBarView,
    required this.sibmitButtonView,
  });

  final PreferredSizeWidget appBarView;
  final Widget searchBarView;
  final Widget sibmitButtonView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView,
      body: Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(newChatProviderProvider);

          // 현재 데이터를 불러오고 있는 경우.
          if (data.isLoading) {
            return Center(
              child: GrimityCircularProgressIndicator(),
            );
          }

          // 현재 팔로잉하고 있는 사용자가 아예 없는 경우.
          if (data.value!.followings.isEmpty
           && data.value!.keyword == null) {
            return ListView(
              children: [
                GrimityStateView.user(
                  title: "아직 팔로우하는 작가가 없어요",
                  subTitle: "관심 있는 작가를 팔로우하고\n메세지를 주고 받아보세요",
                ),
              ],
            );
          }

          return Column(
            children: [
              searchBarView,
              Expanded(
                child: InfiniteScrollPagination(
                  isEnabled: data.value!.nextCursor != null,
                  onLoadMore: ref.read(newChatProviderProvider.notifier).loadMore,
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemCount: data.value!.followings.length,
                    itemBuilder: (context, index) {
                      return NewChatScrollItemView(model: data.value!.followings[index]);
                    },
                  ),
                ),
              ),
              sibmitButtonView,
            ],
          );
        },
      ),
    );
  }
}
