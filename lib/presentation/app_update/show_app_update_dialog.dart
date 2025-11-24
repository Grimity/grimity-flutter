import 'package:flutter/material.dart';
import 'package:grimity/app/update/update_factory.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';

void showAppUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => GrimityDialog(
          title: 'Grimity 업데이트 알림',
          content: '더 나은 서비스를 위해 그리미티 앱이\n업데이트 되었습니다. 최신 앱을 설치해주세요.',
          confirmText: '앱 업데이트',
          onConfirm: () => UpdateServiceFactory.create().forceUpdate(),
        ),
  );
}
