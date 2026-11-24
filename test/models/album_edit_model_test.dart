// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/album_edit/models/album_edit_model.dart';

void main() {
  const parent = [
    AlbumBaseResponse(id: 'album-1', name: '첫 앨범'),
    AlbumBaseResponse(id: 'album-2', name: '둘째 앨범'),
  ];

  late AlbumEditModel model;

  setUp(() {
    model = .new(
      albums: parent.toList(),
      parent: parent,
    );
  });

  test('기존 앨범과 동일한 목록이면 제출할 수 없는지 확인', () {
    expect(model.canSubmit, isFalse);

    model.albums[0] = .new(
      id: parent.first.id,
      name: parent.first.name,
    );

    expect(model.canSubmit, isFalse);
  });

  test('앨범을 추가하거나 삭제하면 제출할 수 있는지 확인', () {
    model.albums.add(const .new(id: '', name: '새 앨범'));
    expect(model.canSubmit, isTrue);

    model.albums.removeLast();
    expect(model.canSubmit, isFalse);

    model.albums.removeAt(0);
    expect(model.canSubmit, isTrue);
  });

  test('앨범 이름을 변경하면 제출할 수 있는지 확인', () {
    model.albums[0] = .new(
      id: parent.first.id,
      name: '변경한 앨범',
    );

    expect(model.canSubmit, isTrue);

    model.albums[0] = parent.first;
    expect(model.canSubmit, isFalse);
  });

  test('앨범 순서를 변경하면 제출할 수 있는지 확인', () {
    model.albums.setAll(0, parent.reversed);
    expect(model.canSubmit, isTrue);

    model.albums.setAll(0, parent);
    expect(model.canSubmit, isFalse);
  });
}
