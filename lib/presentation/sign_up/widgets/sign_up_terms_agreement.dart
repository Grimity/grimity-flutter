// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 서비스 이용약관과 개인정보처리방침 링크 및 동의 체크박스를 표시하는 위젯.
class SignUpTermsAgreement extends StatelessWidget {
  const new({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: () => onChanged(!value),
      child: Row(
        spacing: 6,
        children: [
          GdsCheckBox(size: .md, value: value),

          // '서비스이용약관과 개인정보처리방침에 동의합니다.' 표시
          Wrap(
            children: [
              GdsGesture(
                onTap: () {}, // TODO
                child: GdsText(
                  '서비스이용약관',
                  color: .textGrayBold,
                  style: .body1SB,
                  decoration: .underline,
                ),
              ),

              GdsText(
                '과 ',
                color: .textGrayBold,
                style: .body1R,
              ),

              GdsGesture(
                onTap: () {}, // TODO
                child: GdsText(
                  '개인정보처리방침',
                  color: .textGrayBold,
                  style: .body1SB,
                  decoration: .underline,
                ),
              ),

              GdsText(
                '에 동의합니다.',
                color: .textGrayBold,
                style: .body1R,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
