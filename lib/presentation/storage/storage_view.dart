import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:grimity/presentation/storage/enum/storage_type.dart';
import 'package:grimity/presentation/storage/widget/storage_tab_view.dart';
import 'package:grimity/presentation/storage/widget/storage_title_view.dart';

class StorageView extends StatelessWidget {
  const StorageView({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppBarConnection(
      appBars: [
        AppBar(
          behavior: MaterialAppBarBehavior(),
          body: StorageTitleView(),
        ),
        AppBar(
          behavior: AbsoluteAppBarBehavior(),
          body: StorageTabView(controller: tabController),
        ),
      ],
      child: TabBarView(
        controller: tabController,
        children: [
          ...StorageType.values.map((type) => type.buildView()),
        ],
      ),
    );
  }
}
