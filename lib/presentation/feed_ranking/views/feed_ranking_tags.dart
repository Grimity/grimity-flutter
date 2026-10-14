import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_ranking/widgets/feed_ranking_section.dart';
import 'package:pervice/pervice.dart';

/// 인기 태그 정보를 가로 카드 목록으로 표시하는 위젯.
class FeedRankingTags extends StatelessWidget {
  const new({super.key});

  /// 인기 태그를 불러오는 동안 표시할 임시 데이터.
  static final placeholder = List.generate(5, (index) {
    return PopularTagResponse(
      tagName: 'Placeholder',
      thumbnail: '',
    );
  });

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GetTagsPopular.new);

    return FeedRankingSection(
      title: '인기 태그',
      child: service.builder(
        placeholder: placeholder,
        builder: (data) {
          return HorizontalListView.separated(
            clipBehavior: .none,
            itemCount: data.length,
            separatorBuilder: (_, _) => const Gap(16),

            // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
            cacheExtent: 0,
            itemBuilder: (context, index) {
              final tag = data[index];

              return GdsUser.tagView(
                content: tag.tagName,
                thumbnail: tag.thumbnail.toImage(),
              );
            },
          );
        },
      ),
    );
  }
}
