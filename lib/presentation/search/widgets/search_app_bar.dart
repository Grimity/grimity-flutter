import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 검색어를 입력하고 이를 제출하는 앱바 위젯.
class SearchAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.keyword,
  });

  final ValueState<String> keyword;

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.search(
      onBack: context.pop,
      text: keyword.value,
      initialText: keyword.value,
      onSubmitted: keyword.setter,
      placeholder: '그림, 작가, 글을 검색해보세요.',
    );
  }
}
