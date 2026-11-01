// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:grimity/presentation/profile_edit/views/show_profile_link_add_select.dart';
import 'package:grimity/presentation/profile_edit/views/show_profile_link_edit_select.dart';
import 'package:grimity/util/build_draggable_feedback.dart';
import 'package:pervice/pervice.dart';
import 'package:reorderables/reorderables.dart';

/// 프로필 편집 화면에서 외부 링크를 입력하고 이를 수정하는 위젯.
class ProfileEditLinks extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ProfileEditModel> model;

  /// 프로필에 등록할 수 있는 외부 링크의 유형 목록.
  static const linkTypes = [
    'X',
    '픽시브',
    '인스타그램',
    '유튜브',
    '메일',
  ];

  @override
  Widget build(BuildContext context) {
    final sortMode = context.stateOf(() => false);

    return Column(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        // 섹션 헤더 표시
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            GdsText(
              '외부 링크',
              color: .textGrayBold,
              style: .label3,
            ),

            // 편집 모드 전환 버튼 표시
            GdsTransition.fadeThrough(
              alignment: .centerRight,
              value: sortMode(),
              child: GdsButton.text(
                type: .borderless,
                variant: sortMode() ? .primary : .assistive,
                size: .sm,
                label: sortMode() ? '완료' : '순서 편집',
                onTap: sortMode.toggle,
                enabled: model().links.isNotEmpty,
                trailingIcon: sortMode() ? null : .sortHorizontal,
              ),
            ),
          ],
        ),

        // 외부 링크 목록 표시
        ReorderableColumn(
          buildDraggableFeedback: buildDraggableFeedback,
          onReorder: (oldIndex, newIndex) {
            final links = model().links;
            final link = links.removeAt(oldIndex);
            links.insert(newIndex, link);

            model.notifyChanged();
          },
          footer: Align(
            alignment: .centerLeft,
            child: GdsPopoverAnchor.builder(
              builder: (context, layerLink) {
                return GdsButton.text(
                  type: .outlined,
                  size: .md,
                  label: '링크 추가',
                  onTap: () async {
                    final newLink = await showProfileLinkAddSelect(context, layerLink);

                    // 사용자가 링크 유형을 선택했을 경우.
                    if (newLink != null) {
                      model().links.add(newLink);
                      model.notifyChanged();
                    }
                  },
                  enabled: !sortMode(),
                  leadingIcon: .plus,
                );
              },
            ),
          ),
          children: model().links.indexedBuilder((index, link) {
            // 재빌드 시 자식 위젯들의 상태가 초기화되지 않도록 동일한 키 인스턴스 유지.
            final key = context.stateOf(
              () => ValueKey(index),
              key: ValueKey(index),
            );

            return Padding(
              key: key.value,
              padding: .only(bottom: 8),
              child: _LinkField(
                index: index,
                model: model,
                link: link,
                sortMode: sortMode(),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// 프로필 편집 화면에서 외부 링크의 유형과 주소를 수정하는 위젯.
class _LinkField extends StatelessWidget {
  const new({
    required this.index,
    required this.model,
    required this.link,
    required this.sortMode,
  });

  final int index;
  final ValueState<ProfileEditModel> model;
  final LinkResponse link;
  final bool sortMode;

  @override
  Widget build(BuildContext context) {
    final isPredefinedLink = ProfileEditLinks.linkTypes.contains(link.linkName);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          // 링크 이름
          if (isPredefinedLink) ...[
            Expanded(
              child: GdsPopoverAnchor.builder(
                builder: (context, layerLink) {
                  return GdsFilter(
                    variant: .outline,
                    label: link.linkName,
                    onTap: () => onEdit(context, layerLink),
                  );
                },
              ),
            ),
          ] else ...[
            Expanded(
              child: GdsTextField.normal(
                initialText: link.linkName,
                placeholder: '직접 입력',
                size: .md,
                onChanged: (value) {
                  final links = model().links;
                  final index = links.indexOf(link);

                  links[index] = .new(
                    linkName: value,
                    link: link.link,
                  );

                  model.notifyChanged();
                },
              ),
            ),
          ],

          // 링크 내용
          Expanded(
            flex: 2,
            child: GdsGroup(
              initialText: link.link,
              placeholder: '링크 주소',
              status: sortMode ? .selected : .delete,
              onTap: sortMode ? null : onDelete,
              dragHandleBuilder: (context, child) {
                return ReorderableDragStartListener(
                  enabled: sortMode,
                  index: index,
                  child: child,
                );
              },
              onChanged: (value) {
                final links = model().links;
                final index = links.indexOf(link);

                links[index] = .new(
                  linkName: link.linkName,
                  link: value,
                );

                model.notifyChanged();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 링크 유형 선택 화면을 열고 선택한 유형을 반영합니다.
  Future<void> onEdit(BuildContext context, LayerLink layerLink) async {
    final newLink = await showProfileLinkEditSelect(
      context,
      layerLink,
      link: link,
    );

    // 사용자가 링크 유형을 선택했을 경우.
    if (context.mounted && newLink != null) {
      final links = model().links;
      final index = links.indexOf(link);

      links[index] = newLink;
      model.notifyChanged();
    }
  }

  /// 해당 링크를 삭제하고 변경을 알립니다.
  void onDelete() {
    model().links.remove(link);
    model.notifyChanged();
  }
}
