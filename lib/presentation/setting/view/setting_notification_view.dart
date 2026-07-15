import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/subscription_type.enum.dart';
import 'package:grimity/presentation/common/provider/user_subscribe_provider.dart';

class SettingNotificationView extends ConsumerWidget {
  const SettingNotificationView({super.key});

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
    final innerPadding = EdgeInsets.symmetric(horizontal: GdsSpacing.spacing16);

    return ListView(
      children: [
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '모든 알림',
            state: allSubscription ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap: () => toggleAllSubscription(ref, value: !allSubscription),
          ),
        ),
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '팔로우 알림',
            state: follow ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap: () => toggleSubscription(ref, value: !follow, list: subscriptionList, type: SubscriptionType.follow),
          ),
        ),
        GdsListItem.section(text: '그림'),
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '좋아요 알림',
            state: feedLike ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap:
                () =>
                    toggleSubscription(ref, value: !feedLike, list: subscriptionList, type: SubscriptionType.feedLike),
          ),
        ),
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '새 댓글 알림',
            state: feedComment ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap:
                () => toggleSubscription(
                  ref,
                  value: !feedComment,
                  list: subscriptionList,
                  type: SubscriptionType.feedComment,
                ),
          ),
        ),
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '새 답글 알림',
            state: feedReply ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap:
                () => toggleSubscription(
                  ref,
                  value: !feedReply,
                  list: subscriptionList,
                  type: SubscriptionType.feedReply,
                ),
          ),
        ),
        GdsListItem.section(text: '자유게시판'),
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '새 댓글 알림',
            state: postComment ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap:
                () => toggleSubscription(
                  ref,
                  value: !postComment,
                  list: subscriptionList,
                  type: SubscriptionType.postComment,
                ),
          ),
        ),
        Padding(
          padding: innerPadding,
          child: GdsControlItem.toggle(
            text: '새 답글 알림',
            state: postReply ? GdsControlItemState.pressed : GdsControlItemState.enabled,
            variant: GdsControlItemVariant.normal,
            onTap:
                () => toggleSubscription(
                  ref,
                  value: !postReply,
                  list: subscriptionList,
                  type: SubscriptionType.postReply,
                ),
          ),
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
