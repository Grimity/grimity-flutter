import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(pinned: true, floating: false, delegate: _SearchAppBarDelegate());
  }
}

class _SearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _SearchAppBarDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(Icons.arrow_back_ios_new_outlined, size: 24.w),
          ),
          Gap(8.w),
          Expanded(child: _SearchTextField()),
        ],
      ),
    );
  }

  @override
  double get maxExtent => AppTheme.kToolbarHeight.height;

  @override
  double get minExtent => AppTheme.kToolbarHeight.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _SearchTextField extends HookConsumerWidget {
  const _SearchTextField();

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
        ToastService.showError('두 글자 이상 입력해주세요');
        return;
      }

      FocusScope.of(context).unfocus();

      ref.read(searchKeywordProvider.notifier).setKeyword(kw);
    }

    return GrimityTextField.small(
      controller: controller,
      focusNode: focusNode,
      hintText: '검색어를 입력해주세요',
      maxLines: 1,
      showSearchIcon: true,
      onSearch: () => submit(controller.text),
      onSubmitted: (keyword) => submit(keyword),
    );
  }
}
