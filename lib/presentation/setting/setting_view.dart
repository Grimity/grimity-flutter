import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';

class SettingView extends StatefulWidget {
  const SettingView({
    super.key,
    required this.appbar,
    required this.sideBar,
    required this.initialView,
  });

  final Widget appbar;
  final Widget sideBar;
  final Widget initialView;

  static SettingViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<SettingViewState>();
  }

  @override
  State<StatefulWidget> createState() => SettingViewState();
}

class SettingViewState extends State<SettingView> {
  late final ValueNotifier<Widget> viewNotifier = ValueNotifier(widget.initialView);

  void setView(Widget newView) {
    viewNotifier.value = newView;
  }

  @override
  void dispose() {
    super.dispose();
    viewNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: widget.appbar,
      body: Row(
        children: [
          SizedBox(width: 240, child: widget.sideBar),
          Expanded(
            child: ClipRRect(
              child: ListenableBuilder(
                listenable: viewNotifier,
                builder: (context, _) => viewNotifier.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
