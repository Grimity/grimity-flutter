import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 로그인 제공자의 아이콘을 표시하는 공통 소셜 로그인 버튼.
class SignInButton extends StatelessWidget {
  const new({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final GdsIcon icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: onTap,
      child: GdsContainer(
        height: GdsControlSize.lg.value,
        radius: .md,
        color: .surfaceBase,
        child: Row(
          mainAxisAlignment: .center,
          spacing: 8,
          children: [
            if (icon.type == .semantic) ...[
              icon.build(size: 24, color: .surfaceInverse),
            ] else ...[
              icon.build(size: 24),
            ],

            GdsText(label, color: .surfaceInverse, style: .label1),
          ],
        ),
      ),
    );
  }
}
