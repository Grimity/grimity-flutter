import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppBar extends HookConsumerWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);
    final controller = useTextEditingController(text: keyword);
    final focusNode = useFocusNode();

    useEffect(() {
      if (controller.text != keyword) {
        controller.text = keyword;
      }

      return null;
    }, [keyword]);

    void submit(String keyword) {
      final kw = keyword.trim();

      if (keyword.length < 2) {
        ToastService.showFailure('두 글자 이상 입력해주세요');
        return;
      }

      FocusScope.of(context).unfocus();

      ref.read(searchKeywordProvider.notifier).setKeyword(kw);
    }

    return GdsTopNavigation.search(
      onBack: context.pop,
      field: GdsTextField.search(
        size: GdsTextFieldSize.medium,
        placeholder: '그림, 작가, 글을 검색해보세요.',
        controller: controller,
        focusNode: focusNode,
        onEditingComplete: () => submit(controller.text),
      ),
    );
  }
}
