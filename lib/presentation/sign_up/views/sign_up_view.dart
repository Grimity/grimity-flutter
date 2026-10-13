import 'package:flutter/widgets.dart';

/// 회원가입 단계별 화면과 하단 제출 버튼의 동작을 정의하는 기본 클래스.
abstract class SignUpView {
  /// 하단 액션 바의 제출 버튼 라벨.
  String get label;

  /// 다음 단계, 즉 다음 화면으로 넘어갈 수 있는지 여부.
  bool get canSubmit;

  /// 화면의 스크롤 영역 여백이고 별도로 지정하지 않으면 기본 여백을 사용합니다.
  EdgeInsets? get scrollPadding => null;

  /// 제출 버튼을 누른 경우 호출되며 성공 시 다음 화면을 반환합니다.
  Future<SignUpView?> onSubmit(BuildContext context);

  /// Ref. 상태 관리 편의성을 위해 별도의 컨텍스트가 주어지진 않습니다.
  Widget build(BuildContext context);
}
