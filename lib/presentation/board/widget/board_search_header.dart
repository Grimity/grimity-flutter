import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/board/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/board/provider/board_search_query_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardSearchHeader extends HookConsumerWidget {
  const BoardSearchHeader({super.key, required this.type});

  final PostType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSearchType = ref.watch(searchQueryProvider.select((state) => state.searchType));
    final keyword = ref.read(searchQueryProvider).keyword;
    final searchQueryNotifier = ref.read(searchQueryProvider.notifier);
    final rootContext = rootNavigatorKey.currentContext!;
    final controller = useTextEditingController(text: keyword);
    final focusNode = useFocusNode();

    ref.listen(searchQueryProvider.select((state) => state.keyword), (previous, next) {
      if (controller.text != next) {
        controller.text = next;
      }
    });

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

    void selectSearchType(SearchType searchType) {
      searchQueryNotifier.updateSearchType(searchType);
      Navigator.pop(rootContext);

      if (controller.text.trim().length >= 2) {
        ref.read(boardPostDataProvider(type).notifier).search();
      }
    }

    GdsListItem searchTypeOption(SearchType searchType) {
      return GdsListItem.optionCard(
        text: searchType.displayName,
        state: selectedSearchType == searchType ? GdsListItemState.pressed : GdsListItemState.enabled,
        onTap: () => selectSearchType(searchType),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: GdsSpacing.spacing8,
      children: [
        GdsMenuAnchor(
          builder: (link) {
            return GdsFilter(
              text: selectedSearchType.displayName,
              onTap: () {
                if (context.isTablet) {
                  final bottomSheet = GdsBottomSheet(
                    type: GdsBottomSheetType.tertiary,
                    title: '검색 필터',
                    onClose: () => Navigator.pop(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: GdsSpacing.spacing8,
                      children: [
                        searchTypeOption(SearchType.combined),
                        searchTypeOption(SearchType.name),
                      ],
                    ),
                  );

                  bottomSheet.open(rootContext);
                } else {
                  final menu = GdsMenu(
                    items: [
                      [
                        GdsMenuItem(
                          label: SearchType.combined.displayName,
                          onTap: () => selectSearchType(SearchType.combined),
                        ),
                        GdsMenuItem(
                          label: SearchType.name.displayName,
                          onTap: () => selectSearchType(SearchType.name),
                        ),
                      ],
                    ],
                  );

                  menu.open(rootContext, layerLink: link, position: GdsMenuPosition.left);
                }
              },
            );
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
