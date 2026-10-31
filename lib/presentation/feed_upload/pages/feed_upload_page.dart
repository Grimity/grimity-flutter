// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_image.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';
import 'package:grimity/presentation/feed_upload/models/feed_upload_model.dart';
import 'package:grimity/presentation/feed_upload/views/show_feed_upload_album_select_alert.dart';
import 'package:grimity/presentation/feed_upload/views/show_feed_upload_exit_alert.dart';
import 'package:grimity/presentation/feed_upload/views/show_feed_upload_no_album_alert.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_images.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_image_picker.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_section.dart';
import 'package:grimity/widgets/app_loading_popup.dart';
import 'package:pervice/pervice.dart';

/// 이미지와 제목, 본문, 태그, 앨범을 설정하여 피드를 작성하거나 수정하는 페이지.
class FeedUploadPage extends StatelessWidget {
  const new({
    super.key,
    this.initialFeed,
  });

  /// 수정 시 초기값으로 사용할 기존 피드.
  final FeedDetailResponse? initialFeed;

  /// 기존 피드를 수정하는 모드인지 여부.
  bool get isEdit => initialFeed != null;

  @override
  Widget build(BuildContext context) {
    final model = context.stateOf(() => FeedUploadModel.from(initialFeed));
    final data = model.value;

    // 앨범이 없으면 안내 팝업을, 있으면 앨범 선택 팝업을 표시.
    void selectAlbum() async {
      if (AppUser.albums.isEmpty) {
        showFeedUploadNoAlbumAlert(context);
      } else {
        final newAlbum = await showFeedUploadAlbumSelectAlert(context, data.album);

        // 사용자가 앨범을 선택한 경우 이를 반영.
        if (context.mounted && newAlbum != null) {
          model.value = data.copyWith(album: newAlbum);
        }
      }
    }

    return PopScope(
      canPop: !data.canSubmit,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 작성 취소 확인 팝업 표시.
        showFeedUploadExitAlert(context);
      },
      child: GdsScaffold(
        appBar: GdsTopNavigation.editor(
          onBack: () => Navigator.of(context).maybePop(),
          onTitle: selectAlbum,
          action: .new(
            label: isEdit ? '수정' : '업로드',
            onTap: () => submit(context, model.value),
            enabled: data.canSubmit,
          ),
          title: data.album?.name ?? '전체 앨범',
        ),
        body: SingleChildScrollView(
          padding: context.whenDevice(
            mobile: .only(top: 8, bottom: 16, left: 16, right: 16),
            tablet: .only(top: 24, bottom: 20, left: 20, right: 20),
          ),
          child: Column(
            spacing: 12,
            children: [
              // 이미지가 없으면 선택 버튼, 있으면 이미지 목록을 표시.
              if (data.images.isEmpty) ...[
                FeedUploadImagePicker(model: model),
              ] else ...[
                FeedUploadImages(model: model),
              ],

              // 제목의 입력 필드 표시
              GdsTextField.title(
                size: context.whenDevice(
                  mobile: .sm,
                  tablet: .md,
                ),
                maxLength: 32,
                placeholder: '제목을 입력해주세요',
                initialText: data.title,
                onChanged: (title) => model.value = model.value.copyWith(title: title),
              ),

              // 내용의 입력 필드 표시
              GdsTextArea(
                variant: .text,
                maxLength: 500,
                placeholder: '내용을 입력해주세요',
                initialText: data.content,
                onChanged: (content) => model.value = model.value.copyWith(content: content),
              ),

              // 태그의 입력 필드 표시
              FeedUploadSection(
                title: '태그',
                child: GdsTagSelect(
                  size: context.whenDevice(
                    mobile: .xs,
                    tablet: .md,
                  ),
                  tags: data.tags,
                  onAdded: (tag) {
                    model.value = model.value.copyWith(tags: [...model.value.tags, tag]);
                  },
                  onRemoved: (tag) {
                    final tags = data.tags.toList()..remove(tag);
                    model.value = data.copyWith(tags: tags);
                  },
                ),
              ),

              // 앨범의 입력 필드 표시
              FeedUploadSection(
                title: '앨범',
                child: Align(
                  alignment: .centerStart,
                  child: GdsButton.text(
                    size: .lg,
                    type: .borderless,
                    variant: .assistive,
                    trailingIcon: .chevronRight,
                    label: data.album?.name ?? '전체 앨범',
                    onTap: selectAlbum,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 이미지를 업로드하고 피드를 생성하거나 수정합니다.
  Future<void> submit(BuildContext context, FeedUploadModel model) async {
    final popup = AppLoadingPopup(
      title: '이미지를 업로드 중이에요',
      description: '이미지 업로드 도중 화면을 닫거나\n뒤로가면 업로드가 중단될 수 있어요',
      onAsync: () async {
        final thumbnailIndex = model.images.indexOf(model.thumbnail!);
        final cards = (await AppImage.resolve(model.images, .feed)).names;

        if (isEdit) {
          final service = PutFeedsById(
            id: initialFeed!.id,
            request: .new(
              title: model.title,
              cards: cards,
              content: model.content,
              tags: model.tags,
              thumbnail: cards[thumbnailIndex],
              albumId: model.album?.id,
            ),
          );

          await service.request();

          // 현재 페이지를 닫고 완료 안내 표시.
          return () {
            if (context.mounted) {
              context.pop(true);

              GdsToast.show('피드를 수정했어요', status: .positive);
            }
          };
        } else {
          final service = PostFeeds(
            request: .new(
              title: model.title,
              cards: cards,
              content: model.content,
              tags: model.tags,
              thumbnail: cards[thumbnailIndex],
              albumId: model.album?.id,
            ),
          );

          final response = await service.request();

          // 상세 페이지로 이동하고 완료 안내 표시.
          return () {
            if (context.mounted) {
              context.pushReplacement(
                FeedDetailPage(id: response.id),
              );

              GdsToast.show('그림을 업로드했어요', status: .positive);
            }
          };
        }
      },
    );

    await popup.open(context);
  }
}
