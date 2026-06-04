import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';

class BoardTabHeader extends StatelessWidget {
  const BoardTabHeader({
    super.key,
    required this.selectedType,
    required this.onChanged,
    required this.types,
  });

  /// 현재 선택된 게시글 타입
  final PostType selectedType;

  /// 탭이 변경될 때 호출되는 콜백 함수
  final Function(PostType) onChanged;

  /// 탭에 표시할 게시글 타입 리스트
  final List<PostType> types;

  @override
  Widget build(BuildContext context) {
    void onTap(PostType type) {
      if (type != selectedType) {
        onChanged(type);
      }
    }

    return GdsTab(
      items: types.map((type) => GdsTabItem(label: type.displayName, onTap: () => onTap(type))).toList(),
      index: types.indexOf(selectedType),
    );
  }
}
