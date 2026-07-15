import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/setting/widget/setting_delete_account_dialog.dart';

class SettingAccountView extends ConsumerWidget {
  const SettingAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              GdsListItem.rightIcon(
                text: '닉네임',
                subText: user?.name,
                state: GdsListItemState.enabled,
                onTap: () => SettingNicknameRoute().push(context),
              ),
              GdsListItem.rightIcon(
                text: '프로필 URL',
                state: GdsListItemState.enabled,
                onTap: () => SettingProfileUrlRoute().push(context),
              ),
              GdsListItem.textLarge(
                text: '로그아웃',
                state: GdsListItemState.enabled,
                isNegative: false,
                onTap: () => _signOut(context, ref),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: GdsSpacing.spacing40),
          child: GdsTextButton(
            text: '탈퇴하기',
            variant: GdsTextButtonVariant.assistive,
            onPressed: () => showDeleteAccountDialog(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    return ref.read(userAuthProvider.notifier).performSignOut(context);
  }
}
