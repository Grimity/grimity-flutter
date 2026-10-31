// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:url_launcher/url_launcher.dart';

/// 글의 HTML 본문과 조회 수, 작성일을 표시하는 위젯.
class PostDetailContent extends StatelessWidget {
  const new({
    super.key,
    required this.data,
    required this.viewCount,
  });

  final PostDetailResponse data;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 16,
        children: [
          // HTML 본문 표시
          GdsEditorViewer(
            html: data.content,
            imageBuilder: (context, url) {
              return GdsGesture(
                onTap: () {}, // TODO
                child: GdsImage(provider: url.toImage()),
              );
            },
            onLinkTap: (url) async {
              // 링크를 외부 브라우저 또는 연결된 앱으로 열기.
              final opened = await launchUrl(Uri.parse(url), mode: .externalApplication);
              if (!opened) {
                GdsToast.show('링크를 열 수 없어요', status: .negative);
              }
            },
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
