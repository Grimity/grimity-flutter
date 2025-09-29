import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/search/widget/search_app_bar.dart';
import 'package:grimity/presentation/search/widget/tab_bar_widget.dart';
import 'package:grimity/presentation/search/widget/search_content_widget.dart';
import 'package:grimity/presentation/search/widget/category_tags_widget.dart';
import 'package:grimity/presentation/search/provider/search_provider.dart';

class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);

    final isSearching = query.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            SearchAppBar(),
            if (isSearching) ...[
              TabBarWidget(),
              const Expanded(child: SearchContentWidget()),
            ] else ...[
              Expanded(child: CategoryTagsWidget()),
            ],
          ],
        ),
      ),
    );
  }
}
