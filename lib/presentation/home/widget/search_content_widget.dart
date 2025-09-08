import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';
import 'package:grimity/presentation/home/widget/category_tags_widget.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/presentation/common/util/text_highlighter.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import '../../../app/config/app_color.dart';
import '../../../app/config/app_typeface.dart';
import 'empty_state_widget.dart';
import 'search_free_widget.dart';
import 'search_user_widget.dart';

class NoRelatedResult extends StatelessWidget {
  final String keyword;
  const NoRelatedResult({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) => EmptyStateWidget();
}

class SearchContentWidget extends ConsumerWidget {
  const SearchContentWidget({super.key});

  List<String> _terms(String q) =>
      q.trim().isEmpty ? const [] : q.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

  Widget _sortDropdown(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(searchSortProvider);

    final themed = Theme.of(context).copyWith(
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
      hoverColor: Colors.black12,
      focusColor: Colors.black12,
    );

    return Theme(
      data: themed,
      child: DropdownButton<SearchSort>(
        value: sort,
        onChanged: (v) {
          if (v == null) return;
          ref.read(searchSortProvider.notifier).state = v;
        },
        items: SearchSort.values.map((s) {
          final label = switch (s) {
            SearchSort.accuracy => '정확도순',
            SearchSort.recent   => '최신순',
            SearchSort.popular  => '인기순',
          };
          return DropdownMenuItem<SearchSort>(
            value: s,
            child: Text(label, style: AppTypeface.caption1),
          );
        }).toList(),
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.black87,
        style: AppTypeface.caption1.copyWith(color: AppColor.gray800),
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);
    final query       = DrawingHooks.useSearchQuery(ref).trim();
    final terms       = _terms(query);

    if (query.isEmpty) {
      return CategoryTagsWidget();
    }

    switch (selectedTab) {
      case 0:
        final asyncFeeds = ref.watch(searchedFeedsProvider);

        return asyncFeeds.when(
          data: (Feeds f) {
            final items = f.feeds;
            if (items.isEmpty) return NoRelatedResult(keyword: query);

            final total = f.totalCount ?? items.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '검색결과 ', style: AppTypeface.caption1),
                              TextSpan(
                                text: '$total',
                                style: AppTypeface.caption1.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '건', style: AppTypeface.caption1),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _sortDropdown(context, ref),
                    ],
                  ),
                ),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final feed = items[i];
                      return GrimityImageFeed(
                        feed: feed,
                        titleSpan: TextHighlighter.highlight(
                          feed.title ?? '',
                          terms,
                          normalStyle: AppTypeface.label2,
                          highlightStyle: AppTypeface.label2.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('피드 로딩 실패: $e')),
        );

      case 1:
        return const SearchUserWidget();

      case 2:
        return const SearchFreeWidget();

      default:
        return NoRelatedResult(keyword: query);
    }
  }
}
