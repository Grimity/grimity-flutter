import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';

/// 글의 HTML 본문과 조회 수, 작성일을 표시하는 위젯.
class PostDetailContent extends StatelessWidget {
  const new({
    super.key,
    required this.data,
    required this.viewCount,
  });

  /// 본문과 작성일을 표시할 글 상세 정보.
  final PostDetailResponse data;

  /// 화면에 표시할 조회 수.
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 16,
        children: [
          // HTML 본문과 본문에 포함된 이미지 표시.
          GdsEditorViewer(
            html: data.content,
            imageBuilder: (context, url) {
              return GdsGesture(
                onTap: () {}, // TODO
                child: GdsImage(provider: url.toImage()),
              );
            },
            onLinkTap: (url) {}, // TODO
          ),

          // 조회 수와 작성일 표시.
          GdsUserInfo.normal(
            viewCount: viewCount,
            date: data.createdAt,
          ),
        ],
      ),
    );
  }
}
