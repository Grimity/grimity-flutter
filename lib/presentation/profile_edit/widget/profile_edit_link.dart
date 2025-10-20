import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_select_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditLink extends HookConsumerWidget {
  const ProfileEditLink({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileEdit = ref.watch(profileEditProvider);
    final profileEditNotifier = ref.read(profileEditProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("외부 링크", style: AppTypeface.caption1),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => profileEditNotifier.toggleLinkEditing(),
              child: Text(
                profileEdit.isLinkEditing ? "완료" : "순서 편집",
                style: AppTypeface.caption1.copyWith(
                  color: profileEdit.isLinkEditing ? AppColor.main : AppColor.gray500,
                ),
              ),
            ),
          ],
        ),
        Gap(10),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: profileEdit.links.length,
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(elevation: 0, color: Colors.transparent, child: child);
              },
              child: child,
            );
          },
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final links = List<Link>.from(profileEdit.links);
            final item = links.removeAt(oldIndex);
            links.insert(newIndex, item);
            profileEditNotifier.updateLinks(links);
          },
          itemBuilder: (context, index) {
            final link = profileEdit.links[index];
            return LinkWidget(
              key: ValueKey('link-$index'),
              link: link,
              isLinkEditing: profileEdit.isLinkEditing,
              profileEditNotifier: profileEditNotifier,
              index: index,
            );
          },
        ),
        Gap(10),
        GestureDetector(
          onTap:
              () => GrimitySelectModalBottomSheet.show(
                context,
                title: '외부 링크 선택',
                buttons:
                    LinkType.values
                        .map(
                          (e) => GrimitySelectModalButtonModel(
                            title: e.linkName,
                            onTap: () {
                              profileEditNotifier.addLink(Link(linkName: e.linkName, link: e.defaultLink));
                              context.pop();
                            },
                          ),
                        )
                        .toList(),
              ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.profileEdit.add.svg(width: 20, height: 20),
                Gap(4),
                Text("링크 추가", style: AppTypeface.caption1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LinkWidget extends HookConsumerWidget {
  const LinkWidget({
    super.key,
    required this.link,
    required this.isLinkEditing,
    required this.profileEditNotifier,
    required this.index,
  });

  final ProfileEdit profileEditNotifier;
  final Link link;
  final bool isLinkEditing;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkController = useTextEditingController(text: link.link);
    final linkNameController = useTextEditingController(text: link.linkName);

    final linkFocusNode = useFocusNode();
    final linkNameFocusNode = useFocusNode();

    useEffect(() {
      linkController.text = link.link;
      return null;
    }, [link.link]);

    useEffect(() {
      linkNameController.text = link.linkName;
      return null;
    }, [link.linkName]);

    useEffect(() {
      void onLinkFocusChange() {
        if (!linkFocusNode.hasFocus && linkController.text != link.link) {
          profileEditNotifier.updateLinkUrl(link, linkController.text);
        }
      }

      void onLinkNameFocusChange() {
        if (!linkNameFocusNode.hasFocus && linkNameController.text != link.linkName) {
          profileEditNotifier.updateLinkName(link, linkNameController.text);
        }
      }

      linkFocusNode.addListener(onLinkFocusChange);
      linkNameFocusNode.addListener(onLinkNameFocusChange);

      return () {
        linkFocusNode.removeListener(onLinkFocusChange);
        linkNameFocusNode.removeListener(onLinkNameFocusChange);
      };
    }, [linkFocusNode, linkNameFocusNode, link]);

    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          if (!LinkType.isCustomLinkType(link.linkName)) ...[
            SizedBox(
              width: 120.w,
              child: ProfileEditDropdown(
                link: link,
                onChanged: (val) {
                  if (val != null) {
                    profileEditNotifier.updateLinkName(link, val);
                  }
                },
              ),
            ),
          ] else ...[
            SizedBox(
              width: 120.w,
              child: GrimityTextField.normal(
                controller: linkNameController,
                focusNode: linkNameFocusNode,
                hintText: link.linkName,
                maxLines: 1,
              ),
            ),
          ],
          Gap(6),
          Expanded(
            child: GrimityTextField.normal(
              controller: linkController,
              focusNode: linkFocusNode,
              hintText: link.link,
              maxLines: 1,
              onChanged: (val) {
                profileEditNotifier.updateLinkUrl(link, val);
              },
            ),
          ),
          Gap(8),
          if (isLinkEditing) ...[
            ReorderableDragStartListener(
              index: index,
              child: Assets.icons.profileEdit.dragAndDrop.svg(width: 20, height: 20),
            ),
          ] else ...[
            GestureDetector(
              onTap: () => profileEditNotifier.deleteLink(link),
              child: Assets.icons.profileEdit.delete.svg(width: 20, height: 20),
            ),
          ],
        ],
      ),
    );
  }
}
