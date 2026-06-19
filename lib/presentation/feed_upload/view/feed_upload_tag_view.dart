import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadTagView extends HookConsumerWidget {
  const FeedUploadTagView({super.key});

  static const int _maxTagCount = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final colors = context.gdsColors;
    final tags = ref.watch(feedUploadProvider.select((state) => state.tags));

    useEffect(() {
      void submitDraftOnBlur() {
        if (focusNode.hasFocus) return;
        _addTag(ref, controller);
      }

      focusNode.addListener(submitDraftOnBlur);
      return () => focusNode.removeListener(submitDraftOnBlur);
    }, [focusNode, controller]);

    return Row(
      spacing: GdsSpacing.spacing32,
      children: [
        Text(
          '태그',
          style: GdsTypography.subtitle3.copyWith(
            fontSize: 16,
            color: colors.text.grayBold,
          ),
        ),
        Expanded(
          child: GdsTagSelect.medium(
            tags: tags,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (_) => _addTag(ref, controller),
            onTagRemove: (index, _) => _removeTag(ref, tags, index),
          ),
        ),
      ],
    );
  }

  void _addTag(WidgetRef ref, TextEditingController controller) {
    final tag = _normalizeTag(controller.text);
    if (tag.isEmpty) return;

    final notifier = ref.read(feedUploadProvider.notifier);
    final tags = ref.read(feedUploadProvider).tags;

    if (tags.contains(tag)) {
      ToastService.showFailure('증복된 태그입니다');
      return;
    }

    if (tags.length >= _maxTagCount) {
      ToastService.showFailure('더 이상 태그를 추가할 수 없습니다');
      return;
    }

    notifier.addTag(tag);
    controller.clear();
  }

  void _removeTag(WidgetRef ref, List<String> tags, int index) {
    if (index < 0 || index >= tags.length) return;

    final newTags = [...tags]..removeAt(index);
    ref.read(feedUploadProvider.notifier).updateTags(newTags);
  }

  String _normalizeTag(String text) {
    return text.trim().replaceFirst(RegExp(r'^#+'), '').trim();
  }
}
