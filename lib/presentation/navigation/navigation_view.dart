import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 내비게이션에 표시할 화면의 아이콘, 라벨, 알림 점과 액션 콜백을 정의하는 믹스인.
mixin NavigationView on Widget {
  /// 하단 내비게이션에 표시될 라벨.
  GdsIcon get icon;

  /// 하단 내비게이션 표시된 아이콘.
  String get label;

  /// 해당 탭에 점을 표시하는지 여부.
  bool get showDot => false;

  /// 하단 내비게이션의 액션 버튼을 눌렀을 때 실행할 콜백.
  VoidCallback? get onAction => null;
}
