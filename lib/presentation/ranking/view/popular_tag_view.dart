import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/ranking/provider/popular_tag_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularTagView extends ConsumerWidget {
  const PopularTagView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagAsync = ref.watch(popularTagDataProvider);
    final colors = context.gdsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing24,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
          child: Text(
            '인기 태그',
            style: context.isMobile
                ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                : GdsTypography.title1.copyWith(color: colors.text.grayBold),
          ),
        ),
        tagAsync.when(
          data: (tags) => _PopularTagListView(tags: tags),
          loading: () => Skeletonizer(child: _PopularTagListView(tags: Tag.emptyList)),
          error: (_, _) => GrimityStateView.error(onTap: () => ref.invalidate(popularTagDataProvider)),
        ),
      ],
    );
  }
}

class _PopularTagListView extends StatelessWidget {
  const _PopularTagListView({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return DynamicHeightListView(
      items: tags,
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      itemPadding: EdgeInsets.zero,
      itemBuilder: (context, item) {
        final isLast = item == tags.last;

        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : GdsSpacing.spacing16),
          child: GdsUserCard(
            type: GdsUserCardType.tagView,
            nickname: '',
            tagLabel: item.tagName,
            coverImageUrl: item.thumbnail,
            onTap: () => SearchRoute(keyword: item.tagName).push(context),
          ),
        );
      },
    );
  }
}
