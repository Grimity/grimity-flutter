import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditLink extends HookConsumerWidget {
  const ProfileEditLink({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final profileEdit = ref.watch(profileEditProvider);
    final profileEditNotifier = ref.read(profileEditProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GdsSpacing.spacing8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("외부 링크", style: GdsTypography.label3.copyWith(color: colors.text.grayBold)),

            if (profileEdit.links.isNotEmpty) ...[
              if (profileEdit.isLinkEditing) ...[
                GdsTextButton(
                  text: '완료',
                  onPressed: profileEditNotifier.toggleLinkEditing,
                ),
              ] else ...[
                GdsTextButton(
                  text: '순서 편집',
                  variant: GdsTextButtonVariant.assistive,
                  trailingIcon: GdsIcon.sortHorizontal,
                  onPressed: profileEditNotifier.toggleLinkEditing,
                ),
              ],
            ],
          ],
        ),
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
            final isLast = index == profileEdit.links.length - 1;

            return Padding(
              key: ValueKey('link-$index'),
              padding: isLast ? EdgeInsets.zero : EdgeInsets.only(bottom: GdsSpacing.spacing8),
              child: LinkWidget(
                link: link,
                index: index,
                isLinkEditing: profileEdit.isLinkEditing,
                profileEditNotifier: profileEditNotifier,
              ),
            );
          },
        ),
        GdsOutlinedButton(
          text: '링크 추가',
          leadingIcon: GdsIcon.plus,
          onPressed: () async {
            final link = await openSelectBottomSheet(context);
            if (link != null) {
              profileEditNotifier.addLink(link);
            }
          },
        ),
      ],
    );
  }

  static Future<Link?> openSelectBottomSheet(BuildContext context) {
    final bottomSheet = GdsBottomSheet(
      title: '외부 링크 선택',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: GdsSpacing.spacing8,
        children: [
          ...LinkType.values.map((type) {
            return GdsListItem.optionCard(
              text: type.linkName,
              state: GdsListItemState.enabled,
              onTap: () {
                final link = Link(
                  linkName: type.linkName,
                  link: type.defaultLink,
                );

                context.pop(link);
              },
            );
          }),
        ],
      ),
    );

    return bottomSheet.open<Link?>(context);
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
    final profileEdit = ref.watch(profileEditProvider);
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

    return IntrinsicHeight(
      child: Row(
        spacing: GdsSpacing.spacing8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Builder(
              builder: (context) {
                if (LinkType.from(link).isCustom) {
                  return GdsTextField(
                    controller: linkNameController,
                    focusNode: linkNameFocusNode,
                    placeholder: '직접 입력',
                    onChanged: (val) {
                      profileEditNotifier.updateLinkName(link, val);
                    },
                  );
                }

                return GdsFilter(
                  text: link.linkName,
                  onTap: () async {
                    final newLink = await ProfileEditLink.openSelectBottomSheet(context);
                    if (newLink != null) {
                      profileEditNotifier.updateLinkName(link, newLink.linkName);
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: GdsGroupSetting(
              reorderIndex: index,
              controller: linkController,
              focusNode: linkFocusNode,
              text: linkController.text,
              state: profileEdit.isLinkEditing ? GdsGroupSettingState.enabled : GdsGroupSettingState.delete,
              onChanged: (val) => profileEditNotifier.updateLinkUrl(link, val),
              onTap: () => profileEditNotifier.deleteLink(link),
            ),
          ),
        ],
      ),
    );
  }
}
