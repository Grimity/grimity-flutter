// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';

/// 링크 복사, X와 카카오톡 공유 방법을 선택하는 모달을 엽니다.
Future<void> showShareModal(
  BuildContext context, {
  required String name,
  required String text,
  required String path,
}) async {
  final url = Uri.parse('https://grimity.com/').resolve(path).toString();

  return GdsAdaptiveModal.show(
    context,
    builder: (context) {
      return .new(
        title: '$name 공유',
        children: [
          // 클립보드에 복사하기
          GdsListItem.optionCard(
            icon: .link,
            label: '링크 복사하기',
            onTap: () async {
              await Clipboard.setData(.new(text: url));

              // 모달을 닫고 링크 복사 완료 안내 표시.
              if (context.mounted) {
                context.pop();
                GdsToast.show('링크를 복사했어요', status: .positive);
              }
            },
          ),

          // X으로 공유하기
          GdsListItem.optionCard(
            icon: .logoX,
            label: 'X로 공유',
            onTap: () async {
              final uri = Uri.https('x.com', '/intent/post', {
                'text': text,
                'url': url,
              });

              context.pop();
              await launchUrl(uri, mode: .externalApplication);
            },
          ),

          // 카카오톡으로 공유하기
          GdsListItem.optionCard(
            icon: .logoKakaoSimple,
            label: '카카오톡으로 공유',
            onTap: () async {
              context.pop();

              try {
                final isInstelled = await ShareClient.instance.isKakaoTalkSharingAvailable();

                // 카카오톡이 설치되어 있으면 앱으로 공유.
                if (isInstelled) {
                  await ShareClient.instance.shareScrap(url: url);
                } else {
                  // 미설치 상태에서는 브라우저로 공유.
                  final uri = await WebSharerClient.instance.makeScrapUrl(url: url);

                  await launchBrowser(uri);
                }
              } on PlatformException catch (error) {
                if (error.code == 'CANCELED') {
                  return;
                }
              }
            },
          ),
        ],
      );
    },
  );
}
