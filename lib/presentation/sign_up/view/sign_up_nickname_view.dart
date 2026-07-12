import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_subtitle.dart';

class SignUpNicknameView extends ConsumerWidget {
  const SignUpNicknameView({
    super.key,
    required this.nicknameTextField,
    required this.termAgreeWidget,
  });

  final Widget nicknameTextField;
  final Widget termAgreeWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: context.isMobile ? GdsSpacing.spacing40 : GdsSpacing.spacing48,
        left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
        right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
        bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GdsSpacing.spacing40,
        children: [
          SignUpSubtitle(
            subtitle: '활동명을 정해주세요',
            description: '작품과 함께 그리미티에서 기억될 이름이에요',
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: GdsSpacing.spacing12,
            children: [
              nicknameTextField,
              termAgreeWidget,
            ],
          ),
        ],
      ),
    );
  }
}
