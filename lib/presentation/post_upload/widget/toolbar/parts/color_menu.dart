import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/util/color_util.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/menu_archor_square.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/quill_toolbar_utils.dart';
import 'package:grimity/gen/assets.gen.dart';

enum _Mode { text, background }

class ColorMenu extends HookWidget {
  const ColorMenu._({required this.controller, required this.selectionState, bool isText = true})
    : _mode = isText ? _Mode.text : _Mode.background;

  factory ColorMenu.text({required QuillController controller, required SelectionState selectionState}) =>
      ColorMenu._(controller: controller, selectionState: selectionState, isText: true);

  factory ColorMenu.background({required QuillController controller, required SelectionState selectionState}) =>
      ColorMenu._(controller: controller, selectionState: selectionState, isText: false);

  final QuillController controller;
  final SelectionState selectionState;
  final _Mode _mode;

  static const _colors = [
    Color(0xFF000000),
    Color(0xFF999999),
    Color(0xFFC4C4C4),
    Color(0xFFF34343),
    Color(0xFFF89232),
    Color(0xFFFFC824),
    Color(0xFF3ECF45),
    Color(0xFF44ADF8),
    Color(0xFF3457EF),
    Color(0xFFF13087),
    Color(0xFFA724F8),
    Color(0xFF754611),
  ];

  @override
  Widget build(BuildContext context) {
    final menuController = useMemoized(() => MenuController());
    useEffect(() {
      return () => menuController.close();
    }, [menuController]);

    final color = _mode == _Mode.text ? selectionState.textColor : selectionState.backgroundColor;

    return MenuAnchorSquare(
      menuController: menuController,
      padding: EdgeInsets.all(16),
      icon: Stack(
        children: [
          if (_mode == _Mode.background)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color ?? Colors.transparent,
                  border: Border.all(color: AppColor.gray300, width: 1),
                ),
              ),
            ),
          Assets.icons.editor.textcolor.svg(
            colorFilter:
                (_mode == _Mode.text)
                    ? ColorFilter.mode(AppColor.gray700, BlendMode.srcIn)
                    : color == null || color.equalsHexCode(_colors[2]) || color.equalsHexCode(_colors[5])
                    ? ColorFilter.mode(AppColor.gray700, BlendMode.srcIn)
                    : ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
          ),
          if (_mode == _Mode.text) Positioned(right: 4, bottom: 4, child: Container(width: 4, height: 4, color: color)),
        ],
      ),
      menuChildren: [
        MenuItemButton(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith((_) => Colors.white),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          child: SizedBox(
            width: 94,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _colors.map((c) {
                    final isSelected = c.equalsHexCode(color);

                    return GestureDetector(
                      onTap: () {
                        final hex = c.toHexColor();

                        if (_mode == _Mode.text) {
                          controller.formatSelection(ColorAttribute(isSelected ? null : hex));
                        } else {
                          controller.formatSelection(BackgroundAttribute(isSelected ? null : hex));
                        }
                        menuController.close();
                      },
                      child: _ColorDot(color: c, isSelected: isSelected),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorDot({required this.color, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final size = 26.0;

    return Container(
      width: size,
      height: size,
      decoration:
          isSelected
              ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.gray700, width: 1.5),
                color: AppColor.gray00,
              )
              : BoxDecoration(shape: BoxShape.circle, color: color),
      child:
          isSelected
              ? Center(
                child: Container(
                  width: size - 3.0 - 3.0,
                  height: size - 3.0 - 3.0,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              )
              : null,
    );
  }
}
