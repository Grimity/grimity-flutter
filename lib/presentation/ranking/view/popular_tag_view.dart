import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/ranking/provider/popular_tag_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularTagView extends ConsumerWidget {
  const PopularTagView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagAsync = ref.watch(popularTagDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('인기 태그', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
        ),
        Gap(16),
        tagAsync.when(
          data: (tags) => _PopularTagListView(tags: tags),
          loading: () => Skeletonizer(child: _PopularTagListView(tags: Tag.emptyList)),
          error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(popularTagDataProvider)),
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
    return SizedBox(
      height: 170.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: index == tags.length - 1 ? 16 : 0),
            child: _PopularTagCard(tag: tags[index]),
          );
        },
        itemCount: tags.length,
        separatorBuilder: (context, index) => Gap(12),
      ),
    );
  }
}

class _PopularTagCard extends StatelessWidget {
  const _PopularTagCard({required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO 태그 검색
      },
      child: SizedBox(
        width: 120.w,
        child: Stack(
          children: [
            GrimityImage.big(imageUrl: tag.thumbnail),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.0), Colors.black.withValues(alpha: 0.5)],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(tag.tagName, style: AppTypeface.label1.copyWith(color: AppColor.gray00)),
            ),
          ],
        ),
      ),
    );
  }
}
