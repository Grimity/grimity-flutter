import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_tab_type_provider.g.dart';

@riverpod
class StorageTab extends _$StorageTab {
  @override
  StorageTabType build() => StorageTabType.values.first;

  void changeTab(StorageTabType type) {
    state = type;
  }
}
