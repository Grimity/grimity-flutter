import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/search/provider/recommend_tag_data_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchRecommendTagBar extends ConsumerWidget {
  const SearchRecommendTagBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendTags = ref.watch(recommendTagDataProvider);
    final colors = context.gdsColors;

    final Widget child = recommendTags.when(
      data: (tags) => _SearchTagListView(tags: tags),
      loading: () => Skeletonizer(child: _SearchTagListView(tags: Tag.emptyList)),
      error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(recommendTagDataProvider)),
    );

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: GdsSpacing.spacing6,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: GdsSpacing.spacing16),
            child: Text(
              '추천 태그',
              style: GdsTypography.label5.copyWith(color: colors.text.grayBold),
            ),
          ),
          child,
        ],
      );
    }

    // Tablet
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(left: GdsSpacing.spacing20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '추천 태그',
              style: GdsTypography.subtitle2.copyWith(color: colors.text.grayBold),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _SearchTagListView extends ConsumerWidget {
  const _SearchTagListView({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicHeightListView(
      scrollDirection: ScrollDirection.horizontal,
      items: tags,
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      itemPadding: EdgeInsets.zero,
      itemBuilder: (context, tag) {
        final isLast = tag == tags.last;

        return Padding(
          padding: isLast ? EdgeInsets.zero : EdgeInsets.only(right: GdsSpacing.spacing8),
          child: GdsTag(
            text: tag.tagName,
            size: context.isMobile ? GdsTagSize.small : GdsTagSize.medium,
            onTap: () => ref.read(searchKeywordProvider.notifier).setKeyword(tag.tagName),
          ),
        );
      },
    );
  }
}
