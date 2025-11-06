import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _zeroWidthSpace = '\u200B';

class FeedUploadTagView extends HookConsumerWidget {
  const FeedUploadTagView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: _zeroWidthSpace);
    final focusNode = useFocusNode();
    final isFocused = useState(false);

    useEffect(() {
      void listener() {
        isFocused.value = focusNode.hasFocus;

        // onTapUpOutside 에서 다른 텍스트 필드로 이동하는 경우에는
        // 감지가 되지 않아 포커스 해제 시 이벤트 포착 후 추가 처리
        if (isFocused.value == false) {
          _addTag(ref, controller.text);
          _initTagController(controller);
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return GrimityGesture(
      onTap: () {
        if (!focusNode.hasFocus) {
          focusNode.requestFocus();
        }
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 40, minWidth: double.infinity),
        decoration: BoxDecoration(color: AppColor.gray200, borderRadius: BorderRadius.circular(8)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Wrap(
              spacing: 6,
              children: [
                ...ref.watch(feedUploadProvider).tags.map((tag) => _buildAddedTag(tag)),
                if (isFocused.value == false) _buildMockAddTag(),
                // Wrap 내 TextField 사이즈 픽스 필요
                SizedBox(
                  width: isFocused.value ? 80 : 0,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      prefixText: isFocused.value ? '#' : null,
                      prefixStyle: AppTypeface.caption2.copyWith(color: AppColor.gray500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (value) async {
                      // https://github.com/flutter/flutter/issues/50163
                      // 한글 조합 시 조합 중에는 ''으로 onChanged가 호출되며 생각한 바와 같이 호출되지 않음
                      // ex. (ㄱ -> 가 -> 강)은 6번 호출(ㄱ -> '' -> 가 -> '' -> 강)
                      // 조합 하는 시간을 딜레이 후 값이 같은지 판단 처리
                      await Future.delayed(const Duration(milliseconds: 10));
                      if (value != controller.text) {
                        return;
                      }

                      if (!value.startsWith(_zeroWidthSpace)) {
                        // 1. 마지막 태그 삭제 및 반환
                        final lastTag = ref.read(feedUploadProvider.notifier).removeLastTag();
                        // 2. 마지막 태그 세팅 처리
                        controller.text = _zeroWidthSpace + lastTag;
                      }
                    },
                    // 엔터 키 입력 시
                    onSubmitted: (value) {
                      _addTag(ref, controller.text);
                      _initTagController(controller);

                      // 엔터 시 포커스 해제 되어 포커스 처리
                      focusNode.requestFocus();
                    },
                    // 텍스트 필드 외 다른 곳 터치 시
                    onTapUpOutside: (event) {
                      _addTag(ref, controller.text);
                      _initTagController(controller);

                      // 포커스 해제 처리
                      focusNode.unfocus();
                    },
                    style: AppTypeface.caption2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddedTag(String tag) => Text('#$tag', style: AppTypeface.caption2);

  Widget _buildMockAddTag() => Text('#태그 추가', style: AppTypeface.caption2.copyWith(color: AppColor.gray500));

  // 태그 추가
  void _addTag(WidgetRef ref, String text) {
    ref.read(feedUploadProvider.notifier).addTag(text.replaceAll(_zeroWidthSpace, ''));
  }

  void _initTagController(TextEditingController controller) {
    controller.text = _zeroWidthSpace;
  }
}
