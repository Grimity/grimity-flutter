import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/post_upload/widget/post_add_link_bottom_sheet.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/menu_archor_square.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/quill_toolbar_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';

class ImportMenu extends ConsumerWidget {
  const ImportMenu({super.key, required this.controller});

  final QuillController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchorSquare(
      icon: Assets.icons.editor.import.svg(),
      menuChildren: [
        _menuItem(
          icon: Assets.icons.editor.carmera.svg(),
          label: '그림 업로드',
          onTap: () async {
            await PhotoSelectRoute(type: UploadImageType.post).push(context);
            ref.read(postUploadProvider.notifier).insertImage(controller: controller);
          },
        ),
        _menuItem(
          icon: Assets.icons.editor.link.svg(),
          label: '링크 추가',
          onTap: () {
            final sel = controller.selection;
            final fullText = controller.document.toPlainText();
            final selectedText = sel.isCollapsed ? '' : fullText.substring(sel.start, sel.end);
            final currentUrl = controller.getSelectionStyle().attributes[Attribute.link.key]?.value as String?;
            PostAddLinkBottomSheet.show(
              context,
              initialText: selectedText,
              initialUrl: currentUrl,
              onSubmit: (text, url) => controller.applyLink(text, url),
            );
          },
        ),
      ],
    );
  }

  Widget _menuItem({required Widget icon, required String label, required VoidCallback onTap}) {
    return MenuItemButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed) ? AppColor.gray200 : null,
        ),
      ),
      onPressed: onTap,
      child: Container(
        width: 165,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Row(children: [icon, Gap(10), Text(label, style: AppTypeface.label3.copyWith(color: AppColor.gray700))]),
      ),
    );
  }
}
