import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';

void showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder:
        (builderContext) => GrimityDialog(
          title: '정말 탈퇴하시겠어요?',
          content: '계정 복구는 어려워요.',
          cancelText: '취소',
          confirmText: '탈퇴하기',
          onCancel: () => builderContext.pop(),
          onConfirm: () async {
            final user = ref.read(userAuthProvider);
            if (user == null) return;

            builderContext.pop();
            await completeDeleteUserProcessUseCase.execute(LoginProvider.fromString(user.provider ?? ''));
            if (context.mounted) {
              SignInRoute().go(context);
            }
          },
        ),
  );
}
