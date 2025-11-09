import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/util/share_util.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_modal_bottom_sheet.dart';

void showUploadCompleteDialog(BuildContext context, Feed feed) {
  final feedUrl = AppConfig.buildFeedUrl(feed.id);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => GrimityDialog(
          icon: Assets.icons.feedUpload.uploadSuccess,
          title: '그림이 업로드 되었어요',
          content: '업로드 소식을 공유해보세요',
          confirmText: '닫기',
          onConfirm: () {
            context.pop();
            context.pop();
          },
          linkWidget: GrimityGesture(
            onTap: () => ShareUtil.copyLinkToClipboard(feedUrl),
            child: Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.gray500, width: 1))),
              child: Row(
                spacing: 2.w,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.common.link.svg(
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(AppColor.gray600, BlendMode.srcIn),
                  ),
                  Text('링크 복사하기', style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
                ],
              ),
            ),
          ),
          shareWidget: Row(
            spacing: 6,
            children: [
              Expanded(
                child: GrimityGesture(
                  onTap: () => ShareUtil.shareToTwitter(text: ShareContentType.feed.buildShareText(), url: feedUrl),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColor.gray00,
                      border: Border.all(color: AppColor.gray300, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Assets.icons.common.x.svg(width: 16, height: 16),
                        Text('X에 공유', style: AppTypeface.label2.copyWith(color: AppColor.primary5)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GrimityGesture(
                  onTap:
                      () => ShareUtil.shareToKakao(description: feed.title, imageUrl: feed.thumbnail, linkUrl: feedUrl),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColor.gray00,
                      border: Border.all(color: AppColor.gray300, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Assets.icons.common.kakaotalk.svg(width: 16, height: 16),
                        Text('카카오톡에 공유', style: AppTypeface.label2.copyWith(color: AppColor.primary5)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
  );
}
