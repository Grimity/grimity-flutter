// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/album_edit/models/album_edit_model.dart';
import 'package:pervice/pervice.dart';

/// 앨범 이름을 입력하고 새 앨범을 추가하는 위젯.
class AlbumEditAddField extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<AlbumEditModel> model;

  /// 현재 앨범 편집 상태.
  AlbumEditModel get data => model.value;

  @override
  Widget build(BuildContext context) {
    final albumName = context.stateOf(() => '');
    final isTooLong = albumName.length > 15;

    return GdsInput.title(
      title: '새 앨범 추가',
      helperText: isTooLong ? '앨범명 최대 15자까지만 가능해요' : '앨범은 최대 8개까지 추가 가능합니다.',
      helperStatus: isTooLong ? .error : .enabled,
      field: GdsTextField.normal(
        text: albumName.value,
        size: .md,
        status: isTooLong ? .error : .enabled,
        onChanged: albumName.setter,
        placeholder: '예시 : ‘크로키’ 또는 ‘일러스트’',
      ),
      button: .new(
        label: '추가',
        onTap: () => onAdd(context, albumName),

        // 앨범 이름이 비어 있지 않고 15자 이하일 경우.
        enabled: albumName.isNotEmpty && !isTooLong,
      ),
    );
  }

  /// 중복 여부를 확인하고 새 앨범을 추가합니다.
  void onAdd(
    BuildContext context,
    ValueState<String> albumName,
  ) {
    final text = albumName.trimmed;

    // 등록된 앨범이 최대 개수에 도달했을 경우.
    if (data.albums.length >= 8) {
      GdsToast.show('앨범은 최대 8개까지만 추가 가능해요', status: .negative);
      return;
    }

    // 같은 이름의 앨범이 이미 존재할 경우.
    if (data.albums.any((album) => album.name == text)) {
      GdsToast.show('이미 추가된 앨범이에요', status: .negative);
      return;
    }

    data.albums.add(.new(id: '', name: text));
    model.notifyChanged();
    albumName.value = '';
  }
}
