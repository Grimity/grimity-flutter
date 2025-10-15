import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/search/provider/recommend_tag_data_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';

class SearchRecommendTagView extends ConsumerWidget {
  const SearchRecommendTagView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendTags = ref.watch(recommendTagDataProvider);

    return recommendTags.maybeWhen(
      data: (tags) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('추천 태그', style: AppTypeface.subTitle4.copyWith(color: AppColor.gray700)),
              Wrap(
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
              ),
            ],
          ),
        );
      },
      orElse: () => GrimityCircularProgressIndicator(),
    );
  }
}
