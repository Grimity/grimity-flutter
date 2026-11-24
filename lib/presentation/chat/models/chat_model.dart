// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';

/// 메세지 작성과 이미지에 필요한 입력 데이터를 관리하는 모델.
class ChatModel {
  /// 작성 중인 메시지 내용.
  String content = '';

  /// 답장할 메시지의 아이디.
  String? replyToId;

  /// 메시지에 첨부할 이미지 목록.
  final List<ImageProvider> images = [];

  /// 필수 입력값을 충족하여 제출할 수 있는지 여부.
  bool get canSubmit {
    return content.trim().isNotEmpty || images.isNotEmpty;
  }
}
