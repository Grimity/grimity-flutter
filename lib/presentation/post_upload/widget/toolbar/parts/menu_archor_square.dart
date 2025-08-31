import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'toolbar_buttons.dart';

class MenuAnchorSquare extends StatelessWidget {
  const MenuAnchorSquare({
    super.key,
    required this.icon,
    required this.menuChildren,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.menuController,
  });

  final Widget icon;
  final List<Widget> menuChildren;
  final EdgeInsets padding;
  final MenuController? menuController;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: menuController,
      style: MenuStyle(
        /// menuAnchor의 menuChild가 가상 키보드가 올라왔을때 가려지는 이슈가 있음.
        /// Alignment의 y를 크게하면 위쪽으로 나와서 이렇게 일단 대응..
        /// issue : https://github.com/flutter/flutter/issues/142921
        alignment: Alignment(-1, 50),
        padding: WidgetStatePropertyAll(padding),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        backgroundColor: WidgetStatePropertyAll(AppColor.gray00),
      ),
      alignmentOffset: Offset(0, 12),
      menuChildren: menuChildren,
      builder:
          (context, anchor, child) => IconSquareButton(
            activeColor: AppColor.gray200,
            active: anchor.isOpen,
            onTap: () {
              if (anchor.isOpen) {
                anchor.close();
              } else {
                anchor.open();
              }
            },
            child: icon,
          ),
    );
  }
}
