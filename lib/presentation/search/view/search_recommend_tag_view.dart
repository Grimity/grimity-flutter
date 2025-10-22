import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/search/provider/recommend_tag_data_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchRecommendTagView extends ConsumerWidget {
  const SearchRecommendTagView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendTags = ref.watch(recommendTagDataProvider);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('추천 태그', style: AppTypeface.subTitle4.copyWith(color: AppColor.gray700)),
          recommendTags.when(
            data: (tags) => _SearchTagWrap(tags: tags),
            loading: () => Skeletonizer(child: _SearchTagWrap(tags: Tag.emptyList)),
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(recommendTagDataProvider)),
          ),
        ],
      ),
    );
  }
}

class _SearchTagWrap extends ConsumerWidget {
  const _SearchTagWrap({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 6,
      runSpacing: 8,
      children:
          tags
              .map(
                (tag) => GrimityButton.round(
                  text: tag.tagName,
                  style: ButtonStyleType.line,
                  onTap: () => ref.read(searchKeywordProvider.notifier).setKeyword(tag.tagName),
                ),
              )
              .toList(),
    );
  }
}
