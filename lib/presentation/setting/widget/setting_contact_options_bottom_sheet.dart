import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

void showContactOptionsBottomSheet(BuildContext context) {
  List<GrimityModalButtonModel> buttons = [
    GrimityModalButtonModel(title: '카톡으로 이동', onTap: () async => await launchUrl(Uri.parse(AppConst.openChatUrl))),
    GrimityModalButtonModel(
      title: '메일 링크 복사',
      onTap: () {
        Clipboard.setData(ClipboardData(text: AppConst.contactEmail));
        ToastService.show('이메일이 복사되었습니다!');
      },
    ),
  ];

  GrimityModalBottomSheet.show(context, buttons: buttons);
}
