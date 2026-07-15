import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

Future<void> showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '정말 탈퇴하시겠어요?',
    description: '계정 복구는 어려워요.',
    primaryLabel: '탈퇴하기',
    onPrimaryTap: () async {
      final user = ref.read(userAuthProvider);
      if (user == null) return;

      context.pop();
      await completeDeleteUserProcessUseCase.execute(LoginProvider.fromString(user.provider ?? ''));
      if (context.mounted) {
        SignInRoute().go(context);
      }
    },
    secondaryLabel: '취소',
    onSecondaryTap: context.pop,
  );

  return alert.open(context);
}
