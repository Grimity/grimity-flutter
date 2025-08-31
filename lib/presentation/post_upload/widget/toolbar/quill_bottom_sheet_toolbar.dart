import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/color_menu.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/header_menu.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/import_menu.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/quill_toolbar_utils.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/text_style_group.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/toolbar_container.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/undo_redo_group.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuillBottomSheetToolbar extends ConsumerWidget {
  const QuillBottomSheetToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quillController = ref.watch(postUploadQuillControllerArgumentProvider);
    final selectionState = quillController.currentSelectionState;

    return ToolbarContainer(
      child: Row(
        spacing: 10,
        children: [
          Gap(6),

          /// import(Image, Link),
          ImportMenu(controller: quillController),

          /// undo, redo
          UndoRedoGroup(controller: quillController),

          /// verticalDivider
          _buildVerticalDivider(),

          /// headLine(H1, H2, 본문)
          HeaderMenu(controller: quillController, selectionState: selectionState),

          /// bold, italic, underLine, strikeThrough
          TextStyleGroup(controller: quillController, selectionState: selectionState),

          /// textColor, backgroundColor
          ColorMenu.text(controller: quillController, selectionState: selectionState),
          ColorMenu.background(controller: quillController, selectionState: selectionState),

          Gap(6),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: VerticalDivider(color: AppColor.gray300, width: 1));
}
