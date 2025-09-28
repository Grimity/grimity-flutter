import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/subscription_type.enum.dart';
import 'package:grimity/presentation/common/provider/user_subscribe_provider.dart';

class SettingSubscriptionSection extends ConsumerWidget {
  const SettingSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSubscribeProvider);

    final List<SubscriptionType> subscriptionList = state?.subscription ?? [];
    final follow = subscriptionList.contains(SubscriptionType.follow);
    final feedLike = subscriptionList.contains(SubscriptionType.feedLike);
    final feedComment = subscriptionList.contains(SubscriptionType.feedComment);
    final feedReply = subscriptionList.contains(SubscriptionType.feedReply);
    final postComment = subscriptionList.contains(SubscriptionType.postComment);
    final postReply = subscriptionList.contains(SubscriptionType.postReply);
    final allSubscription = follow && feedLike && feedComment && feedReply && postComment && postReply;

    return ExpansionTile(
      shape: Border(),
      tilePadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text('알림 설정', style: AppTypeface.label1.copyWith(color: AppColor.gray800)),
      children: [
        Divider(height: 1, color: AppColor.gray300),
        _SettingSubscriptionSwitchTile(
          title: '모든 알림',
          value: allSubscription,
          onChanged: (value) => toggleAllSubscription(ref, value: value),
        ),
        Divider(height: 1, color: AppColor.gray300),
        _SettingSubscriptionSwitchTile(
          title: '팔로우 알림',
          value: follow,
          onChanged:
              (value) => toggleSubscription(ref, value: value, list: subscriptionList, type: SubscriptionType.follow),
        ),
        _SettingGroupHeader(title: '그림'),
        _SettingSubscriptionSwitchTile(
          title: '좋아요 알림',
          value: feedLike,
          onChanged:
              (value) => toggleSubscription(ref, value: value, list: subscriptionList, type: SubscriptionType.feedLike),
        ),
        Divider(height: 1, color: AppColor.gray300),
        _SettingSubscriptionSwitchTile(
          title: '새 댓글 알림',
          value: feedComment,
          onChanged:
              (value) =>
                  toggleSubscription(ref, value: value, list: subscriptionList, type: SubscriptionType.feedComment),
        ),
        Divider(height: 1, color: AppColor.gray300),
        _SettingSubscriptionSwitchTile(
          title: '새 답글 알림',
          value: feedReply,
          onChanged:
              (value) =>
                  toggleSubscription(ref, value: value, list: subscriptionList, type: SubscriptionType.feedReply),
        ),
        _SettingGroupHeader(title: '자유게시판'),
        _SettingSubscriptionSwitchTile(
          title: '새 댓글 알림',
          value: postComment,
          onChanged:
              (value) =>
                  toggleSubscription(ref, value: value, list: subscriptionList, type: SubscriptionType.postComment),
        ),
        Divider(height: 1, color: AppColor.gray300),
        _SettingSubscriptionSwitchTile(
          title: '새 답글 알림',
          value: postReply,
          onChanged:
              (value) =>
                  toggleSubscription(ref, value: value, list: subscriptionList, type: SubscriptionType.postReply),
        ),
      ],
    );
  }

  void toggleAllSubscription(WidgetRef ref, {required bool? value}) {
    final tempList = value == true ? SubscriptionType.values.toList() : <SubscriptionType>[];
    ref.read(userSubscribeProvider.notifier).updateSubscription(tempList);
  }

  void toggleSubscription(
    WidgetRef ref, {
    required bool? value,
    required List<SubscriptionType> list,
    required SubscriptionType type,
  }) {
    final tempList = list.toList();
    if (value == true) {
      tempList.add(type);
    } else {
      tempList.remove(type);
    }
    ref.read(userSubscribeProvider.notifier).updateSubscription(tempList);
  }
}

class _SettingSubscriptionSwitchTile extends StatelessWidget {
  const _SettingSubscriptionSwitchTile({required this.title, this.onChanged, required this.value});

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(left: 32, right: 16),
      title: Text(title, style: AppTypeface.label3.copyWith(color: AppColor.gray800)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColor.gray00,
        activeTrackColor: AppColor.main,
        inactiveThumbColor: AppColor.gray00,
        inactiveTrackColor: AppColor.gray400,
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }
          return AppColor.gray400;
        }),
      ),
    );
  }
}

class _SettingGroupHeader extends StatelessWidget {
  const _SettingGroupHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: EdgeInsets.only(left: 32),
      color: AppColor.gray200,
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppTypeface.caption3.copyWith(color: AppColor.gray600)),
    );
  }
}
