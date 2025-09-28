import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/setting/widget/setting_action_tile.dart';
import 'package:grimity/presentation/setting/widget/setting_contact_options_bottom_sheet.dart';
import 'package:grimity/presentation/setting/widget/setting_delete_account_dialog.dart';
import 'package:grimity/presentation/setting/widget/setting_footer.dart';
import 'package:grimity/presentation/setting/widget/setting_notification_section.dart';

class SettingBodyView extends ConsumerWidget {
  const SettingBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        children: [
          SettingSubscriptionSection(),
          divider,
          SettingActionTile(title: '이용 안내', onTap: () => PostDetailRoute(id: AppConst.usageGuidePostId).push(context)),
          divider,
          SettingActionTile(title: '문의하기', onTap: () => showContactOptionsBottomSheet(context)),
          divider,
          SettingActionTile(title: '회원 탈퇴', onTap: () => showDeleteAccountDialog(context, ref)),
          SettingFooter(),
        ],
      ),
    );
  }

  Widget get divider => Divider(height: 1, color: AppColor.gray300);
}
