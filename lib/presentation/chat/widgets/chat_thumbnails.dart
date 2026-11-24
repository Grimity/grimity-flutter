// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/chat/models/chat_model.dart';
import 'package:pervice/pervice.dart';

/// 메시지에 첨부할 이미지 목록을 썸네일로 표시하는 위젯.
class ChatThumbnails extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ChatModel> model;

  @override
  Widget build(BuildContext context) {
    final images = model.value.images;

    return GdsContainer(
      opacity: .opacity80,
      color: .surfaceBlack,
      child: GdsFoldable.builder(
        alignment: .bottomCenter,
        visible: images.isNotEmpty,
        axis: .vertical,
        builder: (context) {
          return HorizontalListView.separated(
            padding: 8.vertical + 16.horizontal,
            separatorBuilder: (_, _) => const Gap(8),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];

              return Stack(
                children: [
                  // 이미지 섬네일 표시
                  GdsThumbnail(
                    width: context.whenDevice(
                      mobile: 60,
                      tablet: 90,
                    ),
                    ratio: .square,
                    radius: .sm,
                    provider: image,
                  ),

                  // 우측 상단에 제거 버튼 표시
                  Positioned(
                    top: 2,
                    right: 2,
                    child: _DeleteButton(
                      onTap: () {
                        model.value.images.remove(image);
                        model.notifyChanged();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// 첨부한 이미지를 목록에서 제거하는 버튼.
class _DeleteButton extends StatelessWidget {
  const new({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: onTap,
      child: GdsContainer(
        color: .bgBlack,
        radius: .xs,
        opacity: .opacity60,
        child: GdsIcon.x.build(size: 16, color: .iconWhite),
      ),
    );
  }
}
