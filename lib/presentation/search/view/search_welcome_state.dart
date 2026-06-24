import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class SearchWelcomeState extends StatelessWidget {
  const SearchWelcomeState({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsEmptyState(
      size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
      icon: GdsIcon.illust,
      title: '그리미티에서 찾아보세요!',
    );
  }
}
