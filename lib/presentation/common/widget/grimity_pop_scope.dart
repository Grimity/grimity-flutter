import 'package:flutter/material.dart';

/// 뒤로 가기 제어 공통 PopScope 위젯
class GrimityPopScope extends StatelessWidget {
  const GrimityPopScope({super.key, required this.child, required this.canPop, required this.callback});

  final Widget child;
  final bool canPop;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop, //false일때는 뒤로가기 금지, true일땐 허용
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        callback.call();
      },
      child: child,
    );
  }
}
