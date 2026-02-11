import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';

class BusinessInfoPage extends StatelessWidget {
  const BusinessInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppTheme.kToolbarHeight.height,
        titleSpacing: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColor.gray300),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              '사업자 정보',
              style: AppTypeface.title2,
            ),
            Gap(24),
            _buildInfoItem('사업자 등록 번호', '408-27-02500'),
            Gap(16),
            _buildInfoItem('법인 여부', '개인'),
            Gap(16),
            _buildInfoItem('상호', '그리미티 (Grimity)'),
            Gap(16),
            _buildInfoItem('대표자명', '임종훈'),
            Gap(16),
            _buildInfoItem('전화번호', '070-8098-7916'),
            Gap(16),
            _buildInfoItem('개업일', '2025-10-11'),
            Gap(16),
            _buildInfoItem('전자우편', 'grimity.official@gmail.com'),
            Gap(16),
            _buildInfoItem('사업장소재지(도로명)', '부산광역시 사상구 가야대로255번길 5, 107동 104호'),
            Gap(16),
            _buildInfoItem('인터넷 도메인', 'https://www.grimity.com/'),
            Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypeface.subTitle3),
        Gap(8),
        Text(content, style: AppTypeface.label3),
      ],
    );
  }
}
