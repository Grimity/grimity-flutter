import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import '../../../domain/entity/feeds.dart';
import 'drawing_card_widget.dart';

class DrawingsGridWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFeeds = ref.watch(searchedFeedsProvider);

    return asyncFeeds.when(
      data: (Feeds f) {
        final items = f.feeds;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('검색결과 ${items.length}건', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) => DrawingCardWidget(feed: items[i]),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('피드 로딩 실패: $e')),
    );
  }
}
