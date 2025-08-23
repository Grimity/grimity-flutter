import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/widget/search_app_bar.dart';
import 'package:grimity/presentation/home/widget/tab_bar_widget.dart';
import 'package:grimity/presentation/home/widget/search_content_widget.dart';

class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchAppBar(),
            TabBarWidget(),
            Expanded(child: SearchContentWidget()),
          ],
        ),
      ),
    );
  }
}
