import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cached_transition/flutter_cached_transition.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:grimity/widgets/app_sidebar.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:pervice/pervice.dart';

/// 상단 내비게이션과 사이드바를 제공하고 하단 탭으로 화면을 전환하는 메인 페이지.
class NavigationPage extends StatelessWidget {
  const new({super.key});

  /// 하단 네비게이션의 각 탭에 대응하는 화면 목록.
  static const _views = <NavigationView>[
    _Test(icon: .home, label: '홈', action: true),
    _Test(icon: .paint, label: '랭킹', action: true),
    _Test(icon: .following, label: '팔로잉', action: false),
    _Test(icon: .board, label: '자유게시판', action: true),
    _Test(icon: .message, label: 'DM', action: false),
  ];

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: AppTopNavigation.main(),
      drawer: const AppSidebar(),
      body: Builder(
        builder: (context) {
          final index = context.stateOf(() => 0);
          assert(index.value < _views.length);

          // 현재 선택된 탭에 대응하는 화면.
          final view = _views[index.value];

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // 페이지 본문 표시
                    CachedTransition(
                      transitionBuilder: transitionBuilder,
                      duration: GdsAnimation.slow.duration,
                      curve: GdsAnimation.slow.curve,
                      child: KeyedSubtree(
                        key: ValueKey(index.value),
                        child: view,
                      ),
                    ),

                    // 하단 액션 버튼 표시
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GdsFadable.builder(
                        type: .scaleFade,
                        visible: view.onAction != null,
                        builder: (context) {
                          return GdsBottomNavigationButton(onTap: view.onAction!);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 하단 네비게이션 표시
              GdsBottomNavigation(
                index: index.value,
                tabs: _views.indexedBuilder((newIndex, view) {
                  return .new(
                    icon: view.icon,
                    label: view.label,
                    showDot: view.showDot,
                    onTap: () => index.value = newIndex,
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 페이지 전환 시 [child]에 수직 공유 축 전환 애니메이션을 적용하는 빌더.
  Widget transitionBuilder(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      transitionType: .vertical,
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      fillColor: GdsAtomicColor.transparent,
      child: child,
    );
  }
}

class _Test extends StatelessWidget with NavigationView {
  const new({
    required this.icon,
    required this.label,
    required this.action,
  });

  final bool action;

  @override
  final GdsIcon icon;

  @override
  final String label;

  @override
  VoidCallback? get onAction => action ? () {} : null;

  @override
  Widget build(BuildContext context) {
    final counter = context.stateOf(() => 0);

    return Center(
      child: GdsGesture(
        onTap: () => counter.value += 1,
        child: GdsText('$label ${counter.value}', color: .textGrayBold, style: .title1),
      ),
    );
  }
}
