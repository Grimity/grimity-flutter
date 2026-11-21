// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/business_info/widgets/business_info_item.dart';

/// 그리미티의 사업자 정보를 표시하는 페이지.
class BusinessInfoPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: GdsTopNavigation.iconButton(
        onBack: context.pop,
        actions: const [],
      ),
      body: GdsScrollable(
        padding: context.whenDevice(
          mobile: 16.all,
          tablet: 24.vertical + 20.horizontal,
        ),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            Padding(
              padding: 8.bottom,
              child: const GdsText(
                '사업자 정보',
                color: .textGrayBold,
                style: .title1,
              ),
            ),

            const BusinessInfoItem(
              label: '사업자 등록 번호',
              value: '408-27-02500',
            ),

            const BusinessInfoItem(
              label: '법인 여부',
              value: '개인',
            ),

            const BusinessInfoItem(
              label: '상호',
              value: '그리미티 (Grimity)',
            ),

            const BusinessInfoItem(
              label: '대표자명',
              value: '임종훈',
            ),

            const BusinessInfoItem(
              label: '전화번호',
              value: '070-8098-7916',
            ),

            const BusinessInfoItem(
              label: '개업일',
              value: '2025-10-11',
            ),

            const BusinessInfoItem(
              label: '전자우편',
              value: 'grimity.official@gmail.com',
            ),

            const BusinessInfoItem(
              label: '사업장소재지(도로명)',
              value: '부산광역시 사상구 가야대로255번길 5, 107동 104호',
            ),

            const BusinessInfoItem(
              label: '인터넷 도메인',
              value: 'https://www.grimity.com/',
            ),
          ],
        ),
      ),
    );
  }
}
