// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:pervice/pervice.dart';

/// 프로필 편집 화면에서 닉네임을 입력하고 이를 수정하는 위젯.
class ProfileEditNickname extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ProfileEditModel> model;

  @override
  Widget build(BuildContext context) {
    return GdsInput.title(
      title: '닉네임',
      field: GdsTextField.normal(
        size: .md,
        placeholder: '닉네임을 입력하세요',
        initialText: model().nickname,
        maxLength: 12,
        onChanged: (value) {
          model.set(model().copyWith(nickname: value));
        },
      ),
    );
  }
}
