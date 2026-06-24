import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return GdsEmptyState(
      size: isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
      icon: GdsIcon.resultNull,
      title: '검색한 결과를 찾을 수 없어요',
      description: '검색어의 단어 수를 줄이거나${isMobile ? '\n' : ''}다른 검색어로 검색해보세요',
    );
  }
}
