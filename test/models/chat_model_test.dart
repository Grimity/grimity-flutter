// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/presentation/chat/models/chat_model.dart';

void main() {
  test('메시지나 이미지 없이 답장 대상만 있으면 제출할 수 없는지 확인', () {
    final model = ChatModel();
    expect(model.canSubmit, isFalse);

    model.content = ' \n\t ';
    model.replyToId = '1';
    expect(model.canSubmit, isFalse);
  });

  test('메시지를 입력하면 제출할 수 있고 지우면 제출할 수 없는지 확인', () {
    final model = ChatModel()..content = ' 메시지\n내용 ';
    expect(model.canSubmit, isTrue);

    model.content = '';
    expect(model.canSubmit, isFalse);
  });

  test('텍스트 없이 이미지만 첨부해도 제출할 수 있는지 확인', () {
    final model = ChatModel()..images.add(const AssetImage('test.png'));
    expect(model.canSubmit, isTrue);

    model.images.clear();
    expect(model.canSubmit, isFalse);
  });
}
