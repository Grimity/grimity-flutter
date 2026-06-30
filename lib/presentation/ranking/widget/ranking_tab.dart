import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';

class RankingTab extends HookConsumerWidget {
  const RankingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularFeedRankingOption = ref.read(popularFeedRankingOptionProvider.notifier);
    final popularRankingOption = ref.watch(popularFeedRankingOptionProvider);
    final tabController = useTabController(
      initialLength: FeedRankingType.values.length,
      initialIndex: popularRankingOption.type.index,
    );

    useEffect(() {
      final selectedIndex = popularRankingOption.type.index;
      if (tabController.index != selectedIndex) {
        tabController.animateTo(selectedIndex);
      }

      return null;
    }, [popularRankingOption.type]);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: ListenableBuilder(
        listenable: tabController,
        builder: (context, child) {
          return GdsTab(
            size: context.isMobile ? GdsTabSize.sm : GdsTabSize.md,
            controller: tabController,
            items: [
              ...FeedRankingType.values.map((type) {
                return GdsTabItem(
                  label: type.displayName,
                  onTap: () {
                    tabController.animateTo(type.index);
                    popularFeedRankingOption.setType(type);
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  static AppBar createAppBar() {
    return AppBar(
      behavior: AbsoluteAppBarBehavior(),
      body: RankingTab(),
    );
  }
}
