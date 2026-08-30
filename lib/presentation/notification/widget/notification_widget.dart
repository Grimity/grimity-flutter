import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/app/linking/url_handler.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_profile.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/domain/entity/notification.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({super.key, required this.notification});

  final Notification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationDataProvider.notifier);
    final colors = context.gdsColors;

    return InkWell(
      onTap: () {
        if (notification.isRead == false) {
          notifier.markNotificationAsRead(notification.id);
        }

        UrlHandler.handleServerUrl(context, notification.link);
      },
      child: Container(
        padding: const EdgeInsets.all(GdsSpacing.spacing16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GrimityUserProfile.fromBuilder(
                imageUrl: notification.image ?? '',
                titleBuilder: () => _buildNotificationText(context, notification.message),
                subTitleBuilder: () => Text(
                  notification.createdAt.toRelativeTime(),
                  style: GdsTypography.caption1.copyWith(
                    color: colors.text.grayNormal.withValues(alpha: notification.isRead ? 0.5 : 1.0),
                  ),
                ),
              ),
            ),
            const Gap(GdsSpacing.spacing8),
            GdsGesture(
              onTap: () => notifier.deleteNotification(notification.id),
              child: GdsIcon.xMark.build(width: 20, height: 20, color: colors.icon.graySubtle),
            ),
          ],
        ),
      ),
    );
  }

  /// bold 처리를 하기 위한 TextWidget
  /// - 문장에 "님이"가 있을 경우: 마지막 "님이" 앞까지를 닉네임으로 인식하여 볼드 처리
  /// - 문장에 "…에 좋아요가" 패턴이 있을 경우: "에 좋아요가" 앞의 대상을 추출하여 볼드 처리
  /// - 두 패턴이 없으면: 전체 문자열을 일반 Text로 반환
  Widget _buildNotificationText(BuildContext context, String message) {
    final styleBase = GdsTypography.body2R.copyWith(
      color: context.gdsColors.text.grayBold.withValues(alpha: notification.isRead ? 0.5 : 1.0),
    );
    final styleBold = GdsTypography.body2SB.copyWith(color: styleBase.color);

    final pattern = RegExp(r'^(.+?)님이|^(.+?)에 좋아요가');
    final matches = pattern.allMatches(message).toList();
    final match = matches.isNotEmpty ? matches.last : null;

    final boldText = match?.group(1) ?? match?.group(2);

    // 매치되는게 없을 때
    if (boldText == null || boldText.isEmpty) {
      return Text(message, style: styleBase, maxLines: 2, overflow: TextOverflow.ellipsis);
    }

    final rest = message.replaceFirst(boldText, '');
    return Text.rich(
      TextSpan(
        style: styleBase,
        children: [
          TextSpan(text: boldText, style: styleBold),
          TextSpan(text: rest),
        ],
      ),
    );
  }
}
