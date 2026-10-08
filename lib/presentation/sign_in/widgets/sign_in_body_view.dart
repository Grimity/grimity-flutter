import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/sign_in/widgets/sign_in_button.dart';

/// 화면 하단에 안내 문구와 소셜 로그인 버튼을 배치하는 위젯.
class SignInBodyView extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onKaKao,
    required this.onApple,
    required this.onGoogle,
  });

  final String title;
  final String subTitle;
  final AsyncCallback onKaKao;
  final AsyncCallback onApple;
  final AsyncCallback onGoogle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .end,
        children: [
          // 제목 표시
          GdsText(
            title,
            color: .textWhite,
            style: context.whenDevice(
              mobile: .title2,
              tablet: .title1,
            ),
          ),
          8.verticalGap,

          // 부제목 표시
          GdsText(subTitle, color: .textWhite, style: .body1R),
          40.verticalGap,

          // 로그인 버튼 표시
          Column(
            mainAxisSize: .min,
            spacing: 12,
            children: [
              SignInButton(
                icon: .logoKakaoSimple,
                label: '카카오로 계속하기',
                onTap: onKaKao,
              ),

              SignInButton(
                icon: .logoGoogle,
                label: '구글로 계속하기',
                onTap: onGoogle,
              ),

              if (Platform.isIOS) ...[
                SignInButton(
                  icon: .logoApple,
                  label: '애플로 계속하기',
                  onTap: onApple,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
