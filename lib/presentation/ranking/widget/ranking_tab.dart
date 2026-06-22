import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';

class RankingTab extends ConsumerWidget {
  const RankingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularFeedRankingOption = ref.read(popularFeedRankingOptionProvider.notifier);
    final popularRankingOption = ref.watch(popularFeedRankingOptionProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: GdsTab(
        size: context.isMobile ? GdsTabSize.sm : GdsTabSize.md,
        index: popularRankingOption.type.index,
        items: [
          ...FeedRankingType.values.map((type) {
            return GdsTabItem(
              label: type.displayName,
              onTap: () => popularFeedRankingOption.setType(type),
            );
          }),
        ],
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
