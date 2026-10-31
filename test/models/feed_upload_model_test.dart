// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter_test/flutter_test.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_upload/models/feed_upload_model.dart';

void main() {
  test('초기 입력값이 없으면 필수 입력값만 채워도 제출할 수 있는지 확인', () {
    final model = FeedUploadModel.from(null);
    expect(model.canSubmit, isFalse);

    const image = ResponsiveImage('https://example.com/image.png');
    final updated = model.copyWith(
      images: [image],
      thumbnail: image,
      title: '제목',
      content: '본문',
    );

    expect(updated.canSubmit, isTrue);
  });

  test('초기 입력값이 있으면 변경 사항이 있어야 제출할 수 있는지 확인', () {
    final model = FeedUploadModel.from(
      FeedDetailResponse(
        id: '',
        title: '제목',
        content: '본문',
        thumbnail: 'https://example.com/image.png',
        cards: ['https://example.com/image.png'],
        tags: [],
        album: null,
        createdAt: DateTime(2026),
        likeCount: 0,
        viewCount: 0,
        commentCount: 0,
        isLike: false,
        isSave: false,
        author: const .new(
          id: '',
          name: '작가',
          url: 'user',
          isBlocked: false,
        ),
      ),
    );

    expect(model.canSubmit, isFalse);

    final updated = model.copyWith(title: '수정한 제목');
    expect(updated.canSubmit, isTrue);
    expect(updated.copyWith(title: model.title).canSubmit, isFalse);
  });
}
