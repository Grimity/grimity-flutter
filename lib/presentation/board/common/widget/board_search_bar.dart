import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/board/common/widget/board_search_by_dropdown.dart';
import 'package:grimity/presentation/board/search/provider/board_search_data_provider.dart';
import 'package:grimity/presentation/board/common/provider/board_search_query_provider.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardSearchBar extends HookConsumerWidget {
  const BoardSearchBar({super.key, this.isOnSearch = false});

  final bool isOnSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQueryState = ref.watch(searchQueryProvider);
    final notifier = ref.read(searchQueryProvider.notifier);
    final controller = useTextEditingController(text: searchQueryState.keyword);
    final focusNode = useFocusNode();

    useEffect(() {
      if (controller.text != searchQueryState.keyword) {
        controller.text = searchQueryState.keyword;
      }

      return null;
    }, [searchQueryState.keyword]);

    void submit() {
      final keyword = controller.text.trim();

      if (keyword.length < 2) {
        ToastService.showError('두 글자 이상 입력해주세요');
        return;
      }

      FocusScope.of(context).unfocus();

      if (isOnSearch) {
        ref.read(searchDataProvider.notifier).search();
      } else {
        BoardSearchRoute().push(context);
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: AppColor.gray100),
      child: Row(
        spacing: 6,
        children: [
          BoardSearchByDropdown(
            type: searchQueryState.searchType,
            onChanged: (searchType) {
              if (searchType == null) return;

              notifier.updateSearchType(searchType);
            },
          ),
          Expanded(
            child: GrimityTextField.small(
              controller: controller,
              focusNode: focusNode,
              hintText: '검색어를 입력해주세요.',
              maxLines: 1,
              showSearchIcon: true,
              onSearch: submit,
              onSubmitted: (_) => submit(),
              onChanged: (keyword) => notifier.updateKeyword(keyword),
            ),
          ),
        ],
      ),
    );
  }
}
