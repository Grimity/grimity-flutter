import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/search/pages/search_page.dart';

/// 프로필 페이지의 상단 탐색 버튼을 표시하는 앱바 위젯.
class ProfileAppBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      onBack: context.pop,
      actions: [
        .new(
          icon: .magnifier,
          onTap: () {
            // 검색 페이지로 이동.
            context.push(SearchPage());
          },
        ),

        .new(
          icon: .inbox,
          onTap: () {}, // TODO
        ),

        .new(
          icon: .settings,
          onTap: () {}, // TODO
        ),
      ],
    );
  }
}
