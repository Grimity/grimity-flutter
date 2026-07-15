import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingContactView extends StatelessWidget {
  const SettingContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GdsListItem.textLarge(
          text: '오픈 카카오톡으로 이동',
          state: GdsListItemState.enabled,
          isNegative: false,
          onTap: () async => await launchUrl(Uri.parse(AppConst.openChatUrl)),
        ),
        GdsListItem.textLarge(
          text: '메일로 보내기',
          state: GdsListItemState.enabled,
          isNegative: false,
          onTap: () {
            Clipboard.setData(ClipboardData(text: AppConst.contactEmail));
            ToastService.showSuccess('메일을 복사했습니다');
          },
        ),
      ],
    );
  }
}
