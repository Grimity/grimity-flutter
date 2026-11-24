// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/album_organize/models/album_organize_model.dart';

void main() {
  final parent = AlbumWithCountResponse(
    id: 'album-id',
    name: '앨범',
    feedCount: 2,
  );

  late AlbumOrganizeModel model;

  setUp(() {
    model = .new(
      parent: parent,
      albumId: parent.id,
      albumName: parent.name,
    );
  });

  test('변경 사항 없이 선택하거나 이동한 그림만 있으면 제출할 수 없는지 확인', () {
    expect(model.canSubmit, isFalse);

    model.checkedFeeds.add('1');
    model.movedFeeds.add('2');
    expect(model.canSubmit, isFalse);
  });

  test('앨범 이름을 변경하면 제출할 수 있고 되돌리면 제출할 수 없는지 확인', () {
    final renamed = model.copyWith(albumName: '새 앨범');
    expect(renamed.canSubmit, isTrue);

    final restored = renamed.copyWith(albumName: parent.name);
    expect(restored.canSubmit, isFalse);
  });

  test('삭제할 그림이 있으면 제출할 수 있고 삭제를 취소하면 제출할 수 없는지 확인', () {
    model.removedFeeds.add('1');
    expect(model.canSubmit, isTrue);

    model.removedFeeds.clear();
    expect(model.canSubmit, isFalse);
  });
}
