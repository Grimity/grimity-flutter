import 'package:flutter/widgets.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

/// 주어진 [Popover] 인스턴스에 따라 해당 오버레이에 표시할 위젯을 생성합니다.
typedef PopoverBuilder = Widget Function(Popover popover);

/// 지정된 위젯을 기준으로 오버레이 형태의 팝업을 보여주는 기능을 제공합니다.
/// 또한 화면 전체 영역을 탭하면 오버레이가 자동으로 닫히도록 설계되었습니다.
class Popover {
  Popover({
    required this.targetLink,
    this.targetAnchor = Alignment.topLeft,
    this.followerAnchor = Alignment.topLeft,
    required this.builder,
  });

  final LayerLink targetLink;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final PopoverBuilder builder;

  OverlayEntry? _entry;

  void show(BuildContext context) {
    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GrimityGesture(onTap: hide),
            ),
            CompositedTransformFollower(
              link: targetLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              showWhenUnlinked: false,
              child: builder(this),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }
}
