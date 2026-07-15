import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/setting/setting_view.dart';
import 'package:grimity/presentation/setting/view/setting_account_view.dart';
import 'package:grimity/presentation/setting/view/setting_contact_view.dart';
import 'package:grimity/presentation/setting/view/setting_notification_view.dart';
import 'package:grimity/presentation/setting/view/setting_theme_view.dart';

class SettingEntryView extends ConsumerWidget {
  const SettingEntryView({super.key});

  static GdsListItemState pressed = GdsListItemState.pressed;
  static GdsListItemState enabled = GdsListItemState.enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navView = SettingView.of(context);

    return ListenableBuilder(
      listenable: navView?.viewNotifier ?? Listenable.merge([]),
      builder: (context, _) {
        final current = navView?.viewNotifier.value;

        return ListView(
          children: [
            GdsListItem.icon(
              text: '내 계정',
              icon: GdsIcon.personOutline,
              state: current is SettingAccountView ? pressed : enabled,
              onTap: () {
                if (context.isMobile) {
                  SettingAccountRoute().push(context);
                } else {
                  assert(navView != null);
                  navView?.setView(SettingAccountView());
                }
              },
            ),
            GdsListItem.icon(
              text: '화면 테마',
              icon: GdsIcon.pallete,
              state: current is SettingThemeView ? pressed : enabled,
              onTap: () {
                if (context.isMobile) {
                  SettingThemeRoute().push(context);
                } else {
                  assert(navView != null);
                  navView?.setView(SettingThemeView());
                }
              },
            ),
            GdsListItem.icon(
              text: '알림',
              icon: GdsIcon.bellOutline,
              state: current is SettingNotificationView ? pressed : enabled,
              onTap: () {
                if (context.isMobile) {
                  SettingNotificationRoute().push(context);
                } else {
                  assert(navView != null);
                  navView?.setView(SettingNotificationView());
                }
              },
            ),
            GdsListItem.icon(
              text: '이용 안내',
              icon: GdsIcon.infoCircleOutline,
              state: GdsListItemState.enabled,
              onTap: () => PostDetailRoute(id: AppConst.usageGuidePostId).push(context),
            ),
            GdsListItem.icon(
              text: '문의하기',
              icon: GdsIcon.infoCircleOutline,
              state: current is SettingContactView ? pressed : enabled,
              onTap: () {
                if (context.isMobile) {
                  SettingContactRoute().push(context);
                } else {
                  assert(navView != null);
                  navView?.setView(SettingContactView());
                }
              },
            ),
          ],
        );
      },
    );
  }
}
