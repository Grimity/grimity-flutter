import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 팔로잉한 작가나 검색 결과가 없을 때 안내를 표시하는 위젯.
class NewChatEmptyState extends StatelessWidget {
  const new({
    super.key,
    required this.keyword,
  });

  final String keyword;

  @override
  Widget build(BuildContext context) {
    return keyword.isEmpty
        ? GdsEmptyState(
            illust: .user,
            title: '팔로우 하는 작가가 없어요',
            description: '관심 있는 작가를 팔로우하고\n메세지를 주고받아 보세요',
          )
        : GdsEmptyState(
            illust: .warning,
            title: '일치하는 작가가 없어요',
            description: '검색어의 단어 수를 줄이거나\n다른 검색어로 검색해보세요.',
          );
  }
}
