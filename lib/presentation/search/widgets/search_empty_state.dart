import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 검색 결과가 없을 때 안내 문구를 표시하는 위젯.
class SearchEmptyState extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topCenter,
      child: GdsEmptyState(
        illust: .resultNull,
        title: '검색한 결과를 찾을 수 없어요',
        description:
            '검색어의 단어 수를 줄이거나${context.isMobile ? '\n' : ' '}'
            '다른 검색어로 검색해보세요.',
      ),
    );
  }
}
