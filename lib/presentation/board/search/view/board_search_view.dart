import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/board/search/provider/board_search_data_provider.dart';
import 'package:grimity/presentation/board/search/view/board_search_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardSearchView extends HookConsumerWidget {
  const BoardSearchView({super.key, required this.boardSearchAppBar, required this.boardSearchBar});

  final Widget boardSearchAppBar;
  final Widget boardSearchBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final searchPostsAsync = ref.watch(searchDataProvider);

    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [boardSearchAppBar, SliverToBoxAdapter(child: boardSearchBar)];
      },
      body: searchPostsAsync.maybeWhen(
        data: (posts) {
          if (posts.posts.isEmpty) {
            return _BoardSearchEmptyView();
          }

          return BoardSearchListView(
            posts: posts.posts,
            totalCount: posts.totalCount ?? 0,
            scrollController: scrollController,
          );
        },
        orElse:
            () => Skeletonizer(
              child: BoardSearchListView(posts: Post.emptyList, totalCount: 0, scrollController: scrollController),
            ),
      ),
    );
  }
}

class _BoardSearchEmptyView extends StatelessWidget {
  const _BoardSearchEmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        spacing: 16,
        children: [
          SvgPicture.asset(Assets.icons.common.resultNull.path, width: 60),
          Text('검색 결과가 없어요.', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
          Text('다른 검색어를 입력해보세요.', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
        ],
      ),
    );
  }
}
