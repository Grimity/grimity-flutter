// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:pervice/pervice.dart';

/// 프로필 편집 화면에서 자기소개를 입력하고 이를 수정하는 위젯.
class ProfileEditDescription extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ProfileEditModel> model;

  @override
  Widget build(BuildContext context) {
    return GdsInput.title(
      title: '자기소개',
      field: GdsTextArea(
        variant: .normal,
        placeholder: '자유롭게 소개를 작성해보세요',
        initialText: model().description,
        maxLength: 500,
        onChanged: (value) {
          model.set(model().copyWith(description: value));
        },
      ),
    );
  }
}
