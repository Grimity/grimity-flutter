// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_urls.dart';
import 'package:url_launcher/url_launcher.dart';

/// 앱 업데이트를 안내하는 팝업을 표시합니다.
Future<void> showAppUpdateAlert(BuildContext context) async {
  final store = Platform.isAndroid
      ? (name: 'Play Store', url: AppUrls.playStore)
      : (name: 'App Store', url: AppUrls.appStore);

  return GdsAlert.show(
    context,
    builder: (context) {
      return GdsAlert(
        title: 'Grimity 업데이트 알림',
        description:
            '더 나은 서비스를 위해 그리미티 앱이\n'
            '업데이트 되었습니다. 최신 앱을 설치해주세요.',
        primaryButton: .new(
          label: '${store.name}로 이동',
          onTap: () {
            // 앱 업데이트를 위해 스토어 페이지 열기.
            launchUrl(Uri.parse(store.url));
          },
        ),
      );
    },
  );
}
