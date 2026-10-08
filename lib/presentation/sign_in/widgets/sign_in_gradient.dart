import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 로그인 화면 하단의 문구와 버튼이 잘 보여질 수 있도록 하는 오버레이 위젯.
class SignInGradient extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsContainer(
      maxHeight: 812,

      // 위쪽의 투명색에서 아래쪽의 80% 불투명한 검정색으로 이어지도록 함.
      gradient: LinearGradient(
        begin: .topCenter,
        end: .bottomCenter,
        colors: [
          GdsAtomicColor.transparent,
          GdsAtomicColor.black.opacity80,
          GdsAtomicColor.black.opacity80,
        ],
      ),
    );
  }
}
