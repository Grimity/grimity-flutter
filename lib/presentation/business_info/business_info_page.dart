import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

class BusinessInfoPage extends StatelessWidget {
  const BusinessInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return GdsScaffold(
      appBar: GdsTopNavigation.iconButton(
        title: '사업자 정보',
        icons: [],
        onBack: context.pop,
        onIconTap: [],
        showTitle: false,
        showIcons: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(GdsSpacing.spacing16),
          children: [
            Text(
              '사업자 정보',
              style: GdsTypography.title1.copyWith(color: colors.text.grayBold),
            ),
            Gap(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing16,
              children: [
                _buildInfoItem(context, '사업자 등록 번호', '408-27-02500'),
                _buildInfoItem(context, '법인 여부', '개인'),
                _buildInfoItem(context, '상호', '그리미티 (Grimity)'),
                _buildInfoItem(context, '대표자명', '임종훈'),
                _buildInfoItem(context, '전화번호', '070-8098-7916'),
                _buildInfoItem(context, '개업일', '2025-10-11'),
                _buildInfoItem(context, '전자우편', 'grimity.official@gmail.com'),
                _buildInfoItem(context, '사업장소재지(도로명)', '부산광역시 사상구 가야대로255번길 5, 107동 104호'),
                _buildInfoItem(context, '인터넷 도메인', 'https://www.grimity.com/'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String title, String content) {
    final colors = context.gdsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing8,
      children: [
        Text(title, style: GdsTypography.subtitle2.copyWith(color: colors.text.grayBold)),
        Text(content, style: GdsTypography.body2R.copyWith(color: colors.text.grayBold)),
      ],
    );
  }
}
