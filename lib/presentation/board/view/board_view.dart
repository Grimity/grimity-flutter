import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/tabs/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/board/tabs/view/board_list_view.dart';
import 'package:grimity/presentation/board/tabs/widget/board_search_header.dart';
import 'package:grimity/presentation/board/tabs/widget/board_tab_header.dart';
import 'package:grimity/presentation/board/tabs/widget/board_title_header.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardView extends HookConsumerWidget {
  const BoardView({super.key, required this.tabList});

  final List<PostType> tabList;

  List<AppBar> buildAppBars(BuildContext context, ValueNotifier<PostType> type) {
    if (context.isMobile) {
      return [
        AppBar(
          behavior: MaterialAppBarBehavior(floating: true),
          body: Padding(
            padding: EdgeInsets.all(GdsSpacing.spacing16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing12,
              children: [
                BoardTitleHeader(),
                BoardSearchHeader(type: type.value),
              ],
            ),
          ),
        ),
        AppBar(
          behavior: AbsoluteAppBarBehavior(),
          body: Padding(
            padding: EdgeInsets.only(
              top: GdsSpacing.spacing4,
              left: GdsSpacing.spacing16,
              right: GdsSpacing.spacing16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing12,
              children: [
                BoardTabHeader(
                  selectedType: type.value,
                  onChanged: (newType) => type.value = newType,
                  types: tabList,
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // 테블릿 버전
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final type = useState(tabList.first);

    return AppBarConnection(
      appBars: buildAppBars(context, type),
      child: Builder(
        builder: (context) {
          final postAsync = ref.watch(boardPostDataProvider(type.value));

          return postAsync.when(
            data:
                (posts) => GrimityRefreshIndicator(
                  onRefresh: () async {
                    await Future.wait([ref.refresh(boardPostDataProvider(type.value).future)]);
                  },
                  child: BoardListView(
                    posts: posts.posts,
                    totalCount: posts.totalCount ?? 0,
                    type: type.value,
                    scrollController: scrollController,
                  ),
                ),
            loading:
                () => Skeletonizer(
                  child: BoardListView(
                    posts: Post.emptyList,
                    totalCount: 0,
                    type: type.value,
                    scrollController: scrollController,
                  ),
                ),
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(boardPostDataProvider(type.value))),
          );
        },
      ),
    );
  }
}
