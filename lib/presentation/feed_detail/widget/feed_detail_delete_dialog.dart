import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';

Future<void> showDeleteFeedAlert(String feedId, BuildContext context, WidgetRef ref) {
  final router = ref.read(routerProvider);

  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '게시글을 삭제할까요?',
    description: '삭제 이후 되돌릴 수 없어요',
    primaryLabel: '삭제',
    onPrimaryTap: () async {
      context.pop();
      final result = await ref.read(feedDetailDataProvider(feedId).notifier).deleteFeed(feedId);

      // 삭제가 성공한 경우 Pop
      if (result) router.pop();
    },
    secondaryLabel: '취소',
    onSecondaryTap: context.pop,
  );

  return alert.open(context);
}
