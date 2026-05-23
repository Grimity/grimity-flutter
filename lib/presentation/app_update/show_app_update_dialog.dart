import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/update/update_factory.dart';

Future<void> showAppUpdateDialog(BuildContext context) {
  final alert = GdsAlert(
    type: GdsAlertType.normal,
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: 'Grimity 업데이트 알림',
    description: '더 나은 서비스를 위해 그리미티 앱이\n업데이트 되었습니다. 최신 앱을 설치해주세요.',
    primaryLabel: '앱 업데이트',
    onPrimaryTap: () => UpdateServiceFactory.create().forceUpdate(),
  );

  return alert.open(context);
}
