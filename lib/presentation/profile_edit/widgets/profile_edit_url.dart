// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:pervice/pervice.dart';

/// 프로필 편집 화면에서 URL, 즉 핸들을 입력하고 이를 수정하는 위젯.
class ProfileEditUrl extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ProfileEditModel> model;

  @override
  Widget build(BuildContext context) {
    return GdsInput.title(
      title: '그리미티 URL',
      field: GdsTextField.normal(
        size: .md,
        initialText: model().url,
        prefixText: 'www.grimity.com/',
        onChanged: (value) {
          model.set(model().copyWith(url: value));
        },
      ),
    );
  }
}
