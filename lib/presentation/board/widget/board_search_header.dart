import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/board/common/provider/board_search_query_provider.dart';
import 'package:grimity/presentation/board/tabs/provider/board_post_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardSearchHeader extends HookConsumerWidget {
  const BoardSearchHeader({super.key, required this.type});

  final PostType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchQueryNotifier = ref.read(searchQueryProvider.notifier);
    final controller = useTextEditingController(text: searchQuery.keyword);
    final focusNode = useFocusNode();

    useEffect(() {
      if (controller.text != searchQuery.keyword) {
        controller.text = searchQuery.keyword;
      }

      return null;
    }, [searchQuery.keyword]);

    void submit() {
      final keyword = controller.text.trim();

      if (keyword.length < 2) {
        ToastService.showFailure('두 글자 이상 입력해주세요');
        return;
      }

      searchQueryNotifier.updateKeyword(keyword);
      FocusScope.of(context).unfocus();
      ref.read(boardPostDataProvider(type).notifier).search();
    }

    void selectSearchType(BuildContext bottomSheetContext, SearchType searchType) {
      searchQueryNotifier.updateSearchType(searchType);
      Navigator.pop(bottomSheetContext);

      if (searchQuery.keyword.trim().length >= 2) {
        ref.read(boardPostDataProvider(type).notifier).search();
      }
    }

    GdsListItem searchTypeOption({
      required BuildContext bottomSheetContext,
      required SearchType searchType,
      required String text,
    }) {
      return GdsListItem.optionCard(
        state: searchQuery.searchType == searchType ? GdsListItemState.pressed : GdsListItemState.enabled,
        text: text,
        onTap: () => selectSearchType(bottomSheetContext, searchType),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: GdsSpacing.spacing8,
      children: [
        GdsFilter(
          text: searchQuery.searchType == SearchType.name ? '글쓴이' : '제목',
          onTap: () {
            final bottomSheet = GdsBottomSheet(
              type: GdsBottomSheetType.tertiary,
              title: '검색 필터',
              onClose: () => Navigator.pop(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: GdsSpacing.spacing8,
                children: [
                  searchTypeOption(
                    bottomSheetContext: context,
                    searchType: SearchType.combined,
                    text: '제목',
                  ),
                  searchTypeOption(
                    bottomSheetContext: context,
                    searchType: SearchType.name,
                    text: '글쓴이',
                  ),
                ],
              ),
            );

            bottomSheet.open(context);
          },
        ),
        Expanded(
          child: GdsTextField.search(
            size: GdsTextFieldSize.small,
            controller: controller,
            focusNode: focusNode,
            placeholder: '검색어를 입력하세요',
            onChanged: (keyword) {
              searchQueryNotifier.updateKeyword(keyword);

              if (keyword.trim().isEmpty) {
                ref.read(boardPostDataProvider(type).notifier).search();
              }
            },
            onEditingComplete: submit,
          ),
        ),
      ],
    );
  }
}
